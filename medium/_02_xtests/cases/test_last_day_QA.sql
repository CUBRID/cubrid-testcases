autocommit off;
create table dual (
	dummy varchar(1)
);
insert into dual values ('X');
select last_day(date '3/19/1999') from dual;
select last_day(date '2/1/1') from dual;
select last_day(date '2/1/1700') from dual;
select last_day(date '2/1/1800') from dual;
select last_day(date '2/1/1900') from dual;
select last_day(date '2/1/1994') from dual;
select last_day(date '2/1/4') from dual;
select last_day(date '2/1/100') from dual;
select last_day(date '2/1/400') from dual;
select last_day(date '2/1/1500') from dual;
select last_day(date '2/1/1600') from dual;
select last_day(date '2/1/1904') from dual;
select last_day(date '2/1/2000') from dual;
drop table dual;
rollback;
