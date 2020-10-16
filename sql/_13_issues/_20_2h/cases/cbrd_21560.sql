drop table if exists foo;

create table foo (a int, b date);

insert into foo values (1, '20170821');
insert into foo values (2, NULL);

drop view if exists foo_v;

create view foo_v as select trunc(date'2020-10-14'-b) d from foo;

select * from foo_v;

drop view if exists foo_v_2;

create view foo_v_2 as select round(date'2020-10-14'-b) d from foo;

select * from foo_v_2;

drop table foo;
drop view foo_v;
drop view foo_v_2;

select round(datetime'2012-12-26 12:10:10', 'dd');
select round(datetime'2012-12-26 12:10:10', 'default');
select round(datetime'2012-12-26 12:10:10');
select trunc(datetime'2012-12-26 12:10:10', 'dd');
select trunc(datetime'2012-12-26 12:10:10', 'default');
select trunc(datetime'2012-12-26 12:10:10');
select round(34567.34567, 'default'), round(34567.34567, 0);
select round(34567.94567, 'default'), round(34567.94567, 0);
select round(34567.34567), round(34567.34567);
select trunc(34567.34567, 'default'), trunc(34567.34567, 0);
select trunc(34567.94567, 'default'), round(34567.94567, 0);
select trunc(34567.34567), trunc(34567.34567);
