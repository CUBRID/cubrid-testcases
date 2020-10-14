drop table if exists foo;

create table foo (a int, b date);

insert into foo values (1, '20170821');
insert into foo values (2, NULL);

create view foo_v as select trunc(sysdate-b) d from foo;

select * from foo_v;

create view foo_v_2 as select round(sysdate-b) d from foo;

select * from foo_v_2;

drop table foo;
