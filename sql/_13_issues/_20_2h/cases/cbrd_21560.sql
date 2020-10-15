drop table if exists foo;

create table foo (a int, b date);

insert into foo values (1, '20170821');
insert into foo values (2, NULL);

create view foo_v as select trunc(sysdate-b) d from foo;

select * from foo_v;

create view foo_v_2 as select round(sysdate-b) d from foo;

select * from foo_v_2;

drop table foo;

select round(datetime'2012-12-26 12:10:10', 'dd');
select round(datetime'2012-12-26 12:10:10', 'default');
select trunc(datetime'2012-12-26 12:10:10', 'dd');
select TRUNC(datetime'2012-12-26 12:10:10', 'default');
select round(34567.34567, 'default'), round(34567.34567, 0);
select round(34567.94567, 'default'), round(34567.94567, 0);
select TRUNC(34567.34567, 'default'), TRUNC(34567.34567, 0);
