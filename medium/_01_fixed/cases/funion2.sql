autocommit off;
select 2 from class db_user
union
select 2.3e0 from class db_user;
rollback;
