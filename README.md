# Barbearia Martins V3 — GitHub Pages

## Publicação
Envie `index.html` e `logo.jpg` para a raiz do repositório e habilite GitHub Pages (main / root). Não envie a pasta inteira como subpasta.

## Contatos
WhatsApp da barbearia: (89) 99403-7817. Instagram: @barbearia_matins.
O WhatsApp abre a mensagem pronta, mas o usuário precisa tocar em Enviar.

## Banco de dados e painel administrativo
1. Crie projeto no Supabase e execute `supabase.sql` no SQL Editor.
2. Em Authentication > Users, crie o usuário administrador com e-mail e senha forte.
3. Copie o UUID desse usuário e execute no SQL Editor:
   `insert into public.admin_users(user_id) values ('UUID-DO-USUARIO');`
4. Edite `index.html` e preencha `SUPABASE_URL` e `SUPABASE_ANON_KEY` com a URL e chave publicável/anon do projeto. NUNCA use a chave `service_role` no HTML.
5. Publique `index.html` e `logo.jpg`. Acesse o botão Admin no topo ou Perfil > Acesso administrativo.
6. No Supabase Auth, configure as políticas de e-mail/senha e proteção contra tentativas excessivas conforme seu plano.

## Relatórios
Receita realizada soma apenas agendamentos marcados como **concluído** pelo administrador. Valor agendado soma reservas **confirmadas**; não é receita recebida. Cancelamentos não entram na receita. Os filtros são dia, semana (segunda a domingo) e mês. Não substitui contabilidade fiscal.

## Limitações antes de produção
Sem Supabase, agendamentos ficam apenas no navegador e o painel seguro não abre. O cliente não recebe WhatsApp automático. É necessário ativar CAPTCHA/rate limit para evitar reservas falsas, definir política de privacidade LGPD, e revisar timezone de Inhuma/PI para validação de horários no servidor. Não existe senha admin embutida no código público.
