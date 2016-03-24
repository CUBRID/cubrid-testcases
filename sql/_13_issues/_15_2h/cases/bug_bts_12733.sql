drop table if exists foo;

//repeat 10 times below queries

create table foo(a int);
grant select on foo to public;
drop table foo;

create table foo(a int);
grant select on foo to public;
drop table foo;

create table foo(a int);
grant select on foo to public;
drop table foo;

create table foo(a int);
grant select on foo to public;
drop table foo;

create table foo(a int);
grant select on foo to public;
drop table foo;

create table foo(a int);
grant select on foo to public;
drop table foo;

create table foo(a int);
grant select on foo to public;
drop table foo;

create table foo(a int);
grant select on foo to public;
drop table foo;

create table foo(a int);
grant select on foo to public;
drop table foo;

create table foo(a int);
grant select on foo to public;
drop table foo;

select count(*) from _db_auth where class_of is null;




