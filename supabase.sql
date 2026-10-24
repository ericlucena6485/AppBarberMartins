-- Execute no SQL Editor do Supabase. Requer PostgreSQL 15+.
create table if not exists public.bookings (
 id bigint generated always as identity primary key,
 customer_name text not null check (length(customer_name) between 2 and 100),
 phone text not null check (phone ~ '^[0-9]{10,13}$'),
 service text not null,
 price numeric(10,2) not null,
 duration_minutes integer not null check(duration_minutes between 15 and 240),
 barber text not null check(barber in ('Nilber','Welio')),
 slot_day date not null,
 slot_time time not null,
 status text not null default 'confirmado' check(status in ('confirmado','cancelado')),
 created_at timestamptz not null default now()
);
create index if not exists bookings_day_barber_idx on public.bookings(slot_day,barber);
alter table public.bookings enable row level security;
-- Não crie políticas públicas para leitura/escrita: acesso só por funções restritas.
revoke all on public.bookings from anon,authenticated;
create or replace function public.public_busy_slots(p_day date,p_barber text)
returns table(slot_time time,duration_minutes integer)
language sql security definer set search_path=public as $$
 select b.slot_time,b.duration_minutes from public.bookings b
 where b.slot_day=p_day and b.barber=p_barber and b.status='confirmado';
$$;
create or replace function public.create_booking(p_name text,p_phone text,p_service text,p_price numeric,p_duration integer,p_barber text,p_day date,p_time time)
returns jsonb language plpgsql security definer set search_path=public as $$
declare new_id bigint; expected_price numeric; expected_duration integer; start_min integer; end_min integer; weekday integer;
begin
 if p_name is null or length(trim(p_name))<2 or length(p_name)>100 or p_phone !~ '^[0-9]{10,13}$' then raise exception 'Dados do cliente inválidos'; end if;
 if p_barber not in ('Nilber','Welio') then raise exception 'Profissional inválido'; end if;
 -- Catálogo validado no servidor (ajuste valores conforme tabela do site)
 select v.price,v.duration into expected_price,expected_duration from (values
 ('Corte Degrade',20::numeric,30),
 ('Corte social',20::numeric,30),
 ('Barba + pezinho',20::numeric,15),
 ('Barba Desenhada',15::numeric,30),
 ('Barba retirada',5::numeric,15),
 ('Cavanhaque',7::numeric,15),
 ('Corte + Barba',32::numeric,30),
 ('Corte + Barba + Sobrancelha',35::numeric,30),
 ('Corte + Pigmentação',40::numeric,60),
 ('Corte + Sobrancelha',25::numeric,30),
 ('Corte americano',20::numeric,30),
 ('Corte Infantil',20::numeric,30),
 ('Corte na tesoura',22::numeric,30),
 ('Corte Navalhado',23::numeric,30),
 ('Corte + Cavanhaque',27::numeric,30),
 ('Hidratação',15::numeric,45),
 ('Luzes',40::numeric,60),
 ('Luzes especial',50::numeric,60),
 ('Moicano',20::numeric,30),
 ('Penteado',15::numeric,30),
 ('Pigmentação no cabelo',30::numeric,60),
 ('Selagem',60::numeric,75),
 ('Sobrancelha',7::numeric,15)
 ) as v(service,price,duration) where v.service=p_service;
 if expected_price is null or p_price<>expected_price or p_duration<>expected_duration then raise exception 'Serviço ou preço inválido'; end if;
 if p_day<current_date or p_day>current_date+60 or (p_day=current_date and p_time<=localtime) then raise exception 'Data inválida'; end if;
 weekday:=extract(dow from p_day);start_min:=extract(hour from p_time)::integer*60+extract(minute from p_time)::integer;end_min:=start_min+p_duration;
 if weekday=0 or (weekday=6 and not ((start_min>=510 and end_min<=750) or (start_min>=780 and end_min<=960))) or (weekday between 1 and 5 and not ((start_min>=510 and end_min<=720) or (start_min>=840 and end_min<=1080))) then raise exception 'Fora do horário de atendimento'; end if;
 if mod(start_min-510,15)<>0 then raise exception 'Horário inválido'; end if;
 perform pg_advisory_xact_lock(hashtext(p_barber),p_day-current_date+100000);
 if exists(select 1 from public.bookings b where b.slot_day=p_day and b.barber=p_barber and b.status='confirmado' and (extract(hour from b.slot_time)::integer*60+extract(minute from b.slot_time)::integer)<end_min and (extract(hour from b.slot_time)::integer*60+extract(minute from b.slot_time)::integer+b.duration_minutes)>start_min) then raise exception 'Este horário já está reservado'; end if;
 insert into public.bookings(customer_name,phone,service,price,duration_minutes,barber,slot_day,slot_time) values(trim(p_name),p_phone,p_service,p_price,p_duration,p_barber,p_day,p_time) returning id into new_id;
 return jsonb_build_object('booking_id',new_id,'status','confirmado');
end;$$;
revoke all on function public.public_busy_slots(date,text) from public;
revoke all on function public.create_booking(text,text,text,numeric,integer,text,date,time) from public;
grant execute on function public.public_busy_slots(date,text) to anon,authenticated;
grant execute on function public.create_booking(text,text,text,numeric,integer,text,date,time) to anon,authenticated;
-- IMPORTANTE: para produção adicionar proteção anti-bot/rate limiting e painel com login.
