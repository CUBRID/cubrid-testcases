autocommit off;
select name from db_user where name+'JOE' like name+name
rollback;
