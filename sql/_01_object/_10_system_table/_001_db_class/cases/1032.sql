--+ holdcas on;
--retrieve from db_class nonexists class
call login ('dba') on class db_user;
select * from db_class
where class_name ='nonexists';
--+ holdcas off;
