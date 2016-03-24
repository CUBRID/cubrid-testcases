-- succeed without any error message(s) 
autocommit off;
grant all privileges on db_user to noone;
revoke select on db_user from noone;

rollback;
