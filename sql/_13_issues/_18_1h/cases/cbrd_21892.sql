drop table if exists foo;
select null into :x;
create table foo (id int) reuse_oid;
insert into foo values (0) into :x;
drop table if exists foo;
drop variable x;
