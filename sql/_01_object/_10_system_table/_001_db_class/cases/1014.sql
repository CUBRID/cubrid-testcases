--+ holdcas on;
--query all system table as dba user;
call login('dba') on class db_user;
select class_name, owner_name, class_type, is_system_class, partitioned
from   db_class
where  is_system_class = 'YES' order by 1,2;
--+ holdcas off;
