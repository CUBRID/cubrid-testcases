-- succeed without any error message(s) 
autocommit off;
grant all privileges on _db_user to noone;
revoke select on _db_user from noone;

rollback;
