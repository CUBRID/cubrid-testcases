--+ holdcas on;
--Qeury all table owned by dba from db_class
drop table if exists ordby_nulls;
call login('dba') on class db_user;
select class_name, owner_name, class_type, is_system_class, partitioned
from   db_class
where  owner_name = 'DBA' and class_name not like 'dml%' order by 1;

--+ holdcas off;
