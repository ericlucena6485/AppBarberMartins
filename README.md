# Barber Martins — protótipo de agendamento

Aplicação React + Vite responsiva, inspirada na estrutura das capturas de tela fornecidas, com design e código próprios.

## Executar

```bash
npm install
npm run dev
```

## Publicar na Vercel

1. Envie esta pasta a um repositório GitHub.
2. Importe o repositório na Vercel.
3. Framework: **Vite**; comando de build: `npm run build`; diretório de saída: `dist`.
4. Faça o deploy e conecte um domínio próprio se desejar.

## IMPORTANTE — protótipo, não produção

Os agendamentos são salvos **apenas no localStorage do navegador**, sem sincronização entre clientes e sem proteção contra conflitos em dispositivos diferentes. Não use para receber reservas reais. Para produção, implementar banco central (ex.: Supabase/Postgres), autenticação, RLS, validação transacional de horários, controles administrativos, políticas de privacidade/LGPD e notificações. Os nomes, preços, horários e contato foram transcritos das imagens de referência e devem ser confirmados com o proprietário. Imagens e logotipos do AppBarber não foram copiados. A foto de capa é uma composição CSS temporária. Links de Instagram e comodidades são demonstrativos e devem ser revisados.

O plano gratuito Hobby da Vercel tem restrições para uso comercial: confira os termos e contrate hospedagem compatível antes de comercializar.
