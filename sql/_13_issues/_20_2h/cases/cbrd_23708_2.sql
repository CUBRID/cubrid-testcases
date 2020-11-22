set system parameters 'create_table_reuseoid=no';

create table a(id int);
create table b(id int) reuse_oid;
create table c(id int) dont_reuse_oid;
create table d(id int) reuse_oid reuseoid;
create table d(id int) dont_reuse_oid dont_reuse_oid;
create table d(id int) reuse_oid dont_reuse_oid;
create table d(id int) dont_reuse_oid reuse_oid;
select class_name, is_reuse_oid_class  from db_class where is_system_class = 'NO';
show create table a;
show create table b;
show create table c;
drop table a;
drop table b;
drop table c;

create table a(id int);
insert into a values(1);
create table b(reuse_oid int);
insert into b values(1);
create table c(dont_reuse_oid int);
insert into c values(1);
select id as reuse_oid, id as dont_reuse_oid from a;
select reuse_oid from b;
select dont_reuse_oid from c;
drop table a;
drop table b;
drop table c;

create table foo(id int,text varchar(32));
insert into foo values(1,'1');
insert into foo values(2,'2');
insert into foo values(3,'3');
insert into foo values(4,'4');
insert into foo values(5,'5');
insert into foo values(6,'6');
select * from foo order by 1;
create table foo2(id int) reuse_oid as select id from foo order by 1;
select * from foo2 order by 1;
show create table foo2;
create table foo3(id int) dont_reuse_oid as select id from foo order by 1;
select * from foo3 order by 1;
show create table foo3;
drop table foo;
drop table foo2;
drop table foo3;

set system parameters 'create_table_reuseoid=yes';
