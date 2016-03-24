--+ holdcas on;
--Qeury all table owned by public from db_class
call login('dba') on class db_user;
select class_name, owner_name, class_type, is_system_class, partitioned
from   db_class
where  owner_name = 'PUBLIC' order by 1,2;

--+ holdcas off;
