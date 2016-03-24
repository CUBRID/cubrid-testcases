create table foo (id int) reuse_oid;

commit;

create table foo2(id foo);

drop table foo2;

create table foo2(ids set of foo);

drop table foo2;

create table foo2 (id int, col foo) reuse_oid;

drop table foo2;

create table foo2 (id int, col set of foo) reuse_oid;

drop table foo2;

insert into foo values (3) into :x;

drop table foo;

