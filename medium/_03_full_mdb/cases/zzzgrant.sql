autocommit off;
call login('dba','') on class db_user;
grant all on big to public;
grant all on med to public;
rollback work;
