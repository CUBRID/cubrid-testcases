--+ holdcas on;
--Query all partitioned table from db_class
call login('dba') on class db_user;
select class_name, owner_name, class_type, is_system_class, partitioned
from   db_class
where  partitioned = 'YES';
--+ holdcas off;
