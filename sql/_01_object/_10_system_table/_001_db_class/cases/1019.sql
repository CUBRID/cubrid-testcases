--+ holdcas on;
--Query all dba's virtual class from db_class

call login('dba') on class db_user;
select class_name, owner_name, class_type, is_system_class, partitioned
from   db_class
where  owner_name = 'DBA' and class_name not like 'dml%'
and    class_type = 'VCLASS' order by 1,2;

--+ holdcas off;
