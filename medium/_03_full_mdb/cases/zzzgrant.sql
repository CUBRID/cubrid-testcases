autocommit off;
call login('dba','') on class db_user;
grant all on public.big to public;
grant all on public.med to public;
rollback work;
