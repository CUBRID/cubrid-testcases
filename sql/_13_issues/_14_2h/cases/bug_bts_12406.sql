--+ holdcas on;
drop table if exists y;
create table y ( b varchar default '', c varchar default null);

select attr_name, default_value from db_attribute where class_name = 'y' order by 1,2;

desc y;

drop table if exists y;
--+ holdcas off;
commit;
 
