-- Supabase SQL Editor에서 전체 실행
create table if not exists public.documents (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 kind text not null check (kind in ('record','material')),
 title text not null,
 year text,
 grade text,
 category text,
 memo text,
 storage_path text not null,
 file_name text not null,
 file_size bigint not null,
 created_at timestamptz not null default now()
);
alter table public.documents enable row level security;
create policy "Users can view own documents" on public.documents for select to authenticated using (auth.uid() = user_id);
create policy "Users can insert own documents" on public.documents for insert to authenticated with check (auth.uid() = user_id);
create policy "Users can delete own documents" on public.documents for delete to authenticated using (auth.uid() = user_id);
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('private-records','private-records',false,20971520,
array['application/pdf','application/msword','application/vnd.openxmlformats-officedocument.wordprocessingml.document','application/vnd.ms-powerpoint','application/vnd.openxmlformats-officedocument.presentationml.presentation','application/vnd.ms-excel','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','image/jpeg','image/png'])
on conflict (id) do update set public=false,file_size_limit=20971520;
create policy "Users upload to own folder" on storage.objects for insert to authenticated
with check (bucket_id='private-records' and (storage.foldername(name))[1]=auth.uid()::text);
create policy "Users read own folder" on storage.objects for select to authenticated
using (bucket_id='private-records' and (storage.foldername(name))[1]=auth.uid()::text);
create policy "Users delete own folder" on storage.objects for delete to authenticated
using (bucket_id='private-records' and (storage.foldername(name))[1]=auth.uid()::text);
