autocommit off;
select NULL from db_user
union
select  1 from  db_user;
select 1 from db_user
union
select NULL from  db_user;
rollback;
