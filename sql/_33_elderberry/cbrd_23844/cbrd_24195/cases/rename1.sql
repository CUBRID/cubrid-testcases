/*
 *      6. RENAME TABLE AND CHANGE OWNER WITH AUTO_INCREMENT, PRIMARY KEY, FOREIGN KEY.
 */

create user u1;
create user u2;
create table t1 (c1 int auto_increment primary key, c2 int, c3 int);
create table t3 (C1 int primary key, c2 int, constraint foreign key (c2) REFERENCES t1 (c1));
create table t4 (c1 int);
create index i1_func on t1 (abs (c2));
create index i2_filter on t1 (c3) where c3 < 0;
call login ('u2') on class db_user;
create table t2 (c1 int);
call login ('dba') on class db_user;
select class_of, unique_name, class_name, owner.name from _db_class where is_system_class % 8 = 0 order by 1,2;
select unique_name, name, owner.name, class_name from db_serial;
select c.class_of, c.unique_name, c.class_name, c.owner.name, i.index_name, k.func, i.filter_expression
from _db_class c, _db_index i, _db_index_key k
where c.unique_name = i.class_of.unique_name
and i.index_name = k.index_of.index_name
and c.is_system_class % 8 = 0 order by 1,2;
show create table t3;
rename table t1 to t2;
select class_of, unique_name, class_name, owner.name from _db_class where is_system_class % 8 = 0 order by 1,2;
select unique_name, name, owner.name, class_name from db_serial;

/* The index name is not changed. */
select c.class_of, c.unique_name, c.class_name, c.owner.name, i.index_name, k.func, i.filter_expression
from _db_class c, _db_index i, _db_index_key k
where c.unique_name = i.class_of.unique_name
and i.index_name = k.index_of.index_name
and c.is_system_class % 8 = 0 order by 1,2;
show create table t3;
rename table t2 to t4;
select class_of, unique_name, class_name, owner.name from _db_class where is_system_class % 8 = 0 order by 1,2;
select unique_name, name, owner.name, class_name from db_serial;
select c.class_of, c.unique_name, c.class_name, c.owner.name, i.index_name, k.func, i.filter_expression
from _db_class c, _db_index i, _db_index_key k
where c.unique_name = i.class_of.unique_name
and i.index_name = k.index_of.index_name
and c.is_system_class % 8 = 0 order by 1,2;
show create table t3;
alter table t2 owner to u1;
select class_of, unique_name, class_name, owner.name from _db_class where is_system_class % 8 = 0 order by 1,2;
select unique_name, name, owner.name, class_name from db_serial;
select c.class_of, c.unique_name, c.class_name, c.owner.name, i.index_name, k.func, i.filter_expression
from _db_class c, _db_index i, _db_index_key k
where c.unique_name = i.class_of.unique_name
and i.index_name = k.index_of.index_name
and c.is_system_class % 8 = 0 order by 1,2;
show create table t3;
alter table u1.t2 owner to u2;
select class_of, unique_name, class_name, owner.name from _db_class where is_system_class % 8 = 0 order by 1,2;
select unique_name, name, owner.name, class_name from db_serial;
select c.class_of, c.unique_name, c.class_name, c.owner.name, i.index_name, k.func, i.filter_expression
from _db_class c, _db_index i, _db_index_key k
where c.unique_name = i.class_of.unique_name
and i.index_name = k.index_of.index_name
and c.is_system_class % 8 = 0 order by 1,2;
show create table t3;

drop table t4;
drop table t3;
drop table u2.t2;
drop table u1.t2;
drop user u2;
drop user u1;

