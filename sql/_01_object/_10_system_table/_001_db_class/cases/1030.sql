--+ holdcas on;
--create class using Constraints UNIQUE and not null and retrieve information from db_class
call login ('dba') on class db_user;
create table t1 (
id int ,
c1 int UNIQUE not null
);

select * from db_class
where class_name = 't1';
drop class t1;
create table t1 (
id int ,
c1 int not null UNIQUE
);
select * from db_class
where class_name = 't1';

drop class t1;
--+ holdcas off;
