-- Ejecutar esto una sola vez en el SQL Editor de tu proyecto Supabase.
-- Crea la tabla donde caen las respuestas del formulario de onboarding
-- (link privado por cliente, no público) sin exponer el resto del CRM.

create table if not exists public.onboarding_submissions (
  id uuid primary key default gen_random_uuid(),
  contact_id text not null,
  payload jsonb not null,
  procesado boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.onboarding_submissions enable row level security;

-- Cualquiera con el link (clave anónima) puede ENVIAR una respuesta,
-- pero no puede leer ni modificar respuestas existentes.
create policy "onboarding_insert_anon"
  on public.onboarding_submissions
  for insert
  to anon
  with check (true);

-- Solo usuarios logueados en el CRM pueden ver / actualizar / borrar respuestas.
create policy "onboarding_select_auth"
  on public.onboarding_submissions
  for select
  to authenticated
  using (true);

create policy "onboarding_update_auth"
  on public.onboarding_submissions
  for update
  to authenticated
  using (true)
  with check (true);

create policy "onboarding_delete_auth"
  on public.onboarding_submissions
  for delete
  to authenticated
  using (true);

-- IMPORTANTE: revisá también la tabla "crm_state" (donde vive todo el CRM).
-- Debería tener RLS habilitado con policies que solo permitan
-- select/insert/update a "authenticated", nunca a "anon". Si no la tenés
-- así configurada, cualquiera con la clave pública podría leer todos tus
-- clientes. Ejemplo de policies equivalentes para esa tabla:
--
-- alter table public.crm_state enable row level security;
-- create policy "crm_state_all_auth" on public.crm_state
--   for all to authenticated using (true) with check (true);
