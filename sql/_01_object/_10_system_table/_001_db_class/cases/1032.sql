--+ holdcas on;
--retrieve from db_class nonexists class
call login ('dba') on class db_user;
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class
where class_name ='nonexists';
--+ holdcas off;
