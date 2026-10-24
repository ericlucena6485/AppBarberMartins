# Barbearia Martins v2 — GitHub Pages + Supabase + WhatsApp

## Publicar a demonstração
Envie `index.html` à raiz do repositório GitHub Pages. Sem configurações, os agendamentos são **simulados localmente** e não servem para clientes reais.

## Ativar reservas reais
1. Crie um projeto em https://supabase.com
2. No SQL Editor execute `supabase.sql`.
3. Em Project Settings / API copie Project URL e chave `anon`/`publishable`. Nunca use a chave `service_role` no HTML.
4. No topo do JavaScript em `index.html`, preencha `SUPABASE_URL` e `SUPABASE_ANON_KEY`.
5. Faça commit e aguarde GitHub Pages atualizar.
6. Teste reservas simultâneas em dois celulares; confira a tabela `bookings` no painel do Supabase.

## WhatsApp
Após salvar, o botão abre o WhatsApp com texto preenchido; o cliente precisa apertar **Enviar**. Não há disparo automático e não há API paga. O telefone está definido no HTML: confira com o dono antes de publicar.

## Logo
Coloque um arquivo autorizado `logo.png` na mesma pasta do `index.html`. O Instagram não disponibilizou uma cópia verificável da logo; não reutilizamos imagem sem acesso ao arquivo.

## Limitações para produção
- O painel administrativo ainda não está implementado. Por enquanto, o dono pode consultar a tabela no Supabase com acesso restrito.
- Cancelamentos reais devem ser realizados pelo administrador no Supabase; o botão local não cancela reservas remotas.
- O catálogo está validado no SQL; atualize preços e duração no HTML **e** no SQL.
- Horários seguem o fuso do banco; configure o fuso da base para America/Sao_Paulo e valide o calendário.
- Antes de uso público: adicionar CAPTCHA/rate limit, política de privacidade LGPD, backups, autenticação administrativa e testes. O plano gratuito pode pausar por inatividade.
