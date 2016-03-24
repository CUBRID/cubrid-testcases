autocommit off;
select name from db_user
union
select name from db_user
order by 1 ,2
select name from db_user
union
select name from db_user
union
select name from db_user
order by 1, 3;
select a from 
(select name from db_user union select name from db_user) as tab(a)
union
select a from 
(select name from db_user union select name from db_user) as tab(a)
order by 1, 2;
rollback;
