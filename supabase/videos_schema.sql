-- Ejecutar una sola vez en el SQL Editor de tu proyecto Supabase.
-- Separa los videos de Métricas del bloque único "crm_state" (que hasta ahora
-- guardaba TODO junto: clientes, tareas, pagos, gastos y videos en un solo
-- registro gigante que se reescribía completo en cada guardado). Con el
-- historial de video creciendo, ese bloque se volvió demasiado pesado y el
-- guardado empezó a fallar ("Empty or invalid json"). Cada video ahora es su
-- propia fila, liviana, independiente del resto del CRM.

create table if not exists public.crm_videos (
  id text primary key,
  client_id text,
  plataforma text,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.crm_videos enable row level security;

create policy "crm_videos_all_auth"
  on public.crm_videos
  for all
  to authenticated
  using (true)
  with check (true);
