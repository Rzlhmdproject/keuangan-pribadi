-- Enable UUID
create extension if not exists "pgcrypto";

-- Profiles
create table if not exists profiles (
  id uuid primary key references auth.users on delete cascade,
  full_name text,
  created_at timestamptz default now()
);

-- Accounts
create table if not exists accounts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade not null,
  name text not null,
  type text not null check (type in ('cash','bank','ewallet','credit')),
  balance numeric(14,2) default 0,
  created_at timestamptz default now()
);

-- Categories
create table if not exists categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade not null,
  name text not null,
  type text not null check (type in ('income','expense','saving','debt')),
  color text default '#3b82f6',
  created_at timestamptz default now()
);

-- Budgets
create table if not exists budgets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade not null,
  category_id uuid references categories on delete cascade not null,
  month text not null, -- 'YYYY-MM'
  amount numeric(14,2) not null default 0,
  unique(user_id, category_id, month)
);

-- Transactions
create table if not exists transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade not null,
  account_id uuid references accounts on delete set null,
  category_id uuid references categories on delete set null,
  type text not null check (type in ('income','expense','saving','debt')),
  amount numeric(14,2) not null check (amount >= 0),
  note text,
  date date not null default current_date,
  status text default 'verified' check (status in ('pending','verified')),
  created_at timestamptz default now()
);

-- Row Level Security
alter table profiles enable row level security;
alter table accounts enable row level security;
alter table categories enable row level security;
alter table budgets enable row level security;
alter table transactions enable row level security;

create policy "own profile" on profiles for all using (auth.uid() = id);
create policy "own accounts" on accounts for all using (auth.uid() = user_id);
create policy "own categories" on categories for all using (auth.uid() = user_id);
create policy "own budgets" on budgets for all using (auth.uid() = user_id);
create policy "own transactions" on transactions for all using (auth.uid() = user_id);

-- Trigger: buat profil + kategori default saat signup
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name', new.email));

  insert into public.categories (user_id, name, type) values
    (new.id, 'Makan & Minum', 'expense'),
    (new.id, 'Transportasi & Bensin', 'expense'),
    (new.id, 'Jajan & Hiburan', 'expense'),
    (new.id, 'Tempat Tinggal & Tagihan', 'expense'),
    (new.id, 'Kebutuhan Pribadi', 'expense'),
    (new.id, 'Gaji', 'income'),
    (new.id, 'Tabungan Goal', 'saving'),
    (new.id, 'Cicilan', 'debt');

  insert into public.accounts (user_id, name, type, balance)
  values (new.id, 'Tunai', 'cash', 0);
  return new;
end; $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
