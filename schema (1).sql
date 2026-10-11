-- Execute no Supabase: SQL Editor > New query > Run
create table equipamentos (
  id uuid primary key default gen_random_uuid(),
  patrimonio text unique not null,
  nome text not null,
  tipo text,
  setor text,
  status text not null default 'Disponível'
    check (status in ('Disponível','Em manutenção','Baixado')),
  periodicidade_dias int,          -- intervalo da preventiva (calendário)
  ultima_preventiva date,
  obs text,
  created_at timestamptz default now()
);

create table registros (
  id uuid primary key default gen_random_uuid(),
  equipamento_id uuid not null references equipamentos(id) on delete cascade,
  tipo text not null check (tipo in ('Pane','Corretiva','Preventiva','Uso','Observação')),
  data date not null default current_date,
  descricao text,
  autor text,
  created_at timestamptz default now()
);

alter table equipamentos enable row level security;
alter table registros enable row level security;

-- Somente usuários autenticados (criados por você em Authentication > Users)
create policy "equipe" on equipamentos for all to authenticated using (true) with check (true);
create policy "equipe" on registros for all to authenticated using (true) with check (true);

-- Depois: Authentication > Providers > Email > desative "Allow new users to sign up"
