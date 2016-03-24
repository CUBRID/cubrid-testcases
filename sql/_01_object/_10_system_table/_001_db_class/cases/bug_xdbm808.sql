--+ holdcas on;
--retrieve from db_class 
drop table if exists ordby_nulls;
call login ('dba') on class db_user;
select * from db_class order by 1,2,3,4,5,6;

--+ holdcas off;
