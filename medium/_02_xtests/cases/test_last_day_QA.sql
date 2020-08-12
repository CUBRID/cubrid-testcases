autocommit off;
create table tb (
	dummy varchar(1)
);
insert into tb values ('X');
select last_day(date '3/19/1999') from tb;
select last_day(date '2/1/1') from tb;
select last_day(date '2/1/1700') from tb;
select last_day(date '2/1/1800') from tb;
select last_day(date '2/1/1900') from tb;
select last_day(date '2/1/1994') from tb;
select last_day(date '2/1/4') from tb;
select last_day(date '2/1/100') from tb;
select last_day(date '2/1/400') from tb;
select last_day(date '2/1/1500') from tb;
select last_day(date '2/1/1600') from tb;
select last_day(date '2/1/1904') from tb;
select last_day(date '2/1/2000') from tb;
drop table tb;
rollback;
