--+ holdcas on;
--create class using Constraints UNIQUE and not null and retrieve information from db_class
call login ('dba') on class db_user;
create table t1 (
id int ,
c1 int UNIQUE not null
);

select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class
where class_name = 't1';
drop class t1;
create table t1 (
id int ,
c1 int not null UNIQUE
);
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class
where class_name = 't1';

drop class t1;
--+ holdcas off;
