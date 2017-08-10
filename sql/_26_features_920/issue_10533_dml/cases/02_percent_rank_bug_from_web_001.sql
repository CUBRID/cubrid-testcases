--02_percent_rank_bug_from_web_001.sql

drop table percent_rank_tab;
CREATE TABLE percent_rank_tab
(
years int,
months int,
amount monetary);

insert into percent_rank_tab values(2011,1,1000);
insert into percent_rank_tab values(2011,2,2000);
insert into percent_rank_tab values(2010,4,2000);
insert into percent_rank_tab values(2011,3,3000);
insert into percent_rank_tab values(2011,4,4000);
insert into percent_rank_tab values(2010,1,5000);
insert into percent_rank_tab values(2010,2,6000);
insert into percent_rank_tab values(2010,3,7000);

select years,months,amount from percent_rank_tab;
select years,months,amount,percent_rank() over(order by amount) from percent_rank_tab;
select years,months,amount,percent_rank() over(order by amount nulls first ) from percent_rank_tab;
select years,months,amount,percent_rank() over(partition by years order by amount) from percent_rank_tab;
select years,months,amount,percent_rank() over(partition by years,months order by amount) from percent_rank_tab;

select * from percent_rank_tab;
drop table percent_rank_tab;

==============================================
drop table percent_rank_tab;
CREATE TABLE percent_rank_tab
(
years int,
months int,
amount monetary);

insert into percent_rank_tab values(2011,1,1000);
insert into percent_rank_tab values(2011,2,2000);
insert into percent_rank_tab values(2011,2,3000);
insert into percent_rank_tab values(2011,2,3000);
insert into percent_rank_tab values(2011,2,4000);
insert into percent_rank_tab values(2010,4,2000);
insert into percent_rank_tab values(2011,3,3000);
insert into percent_rank_tab values(2011,4,4000);
insert into percent_rank_tab values(2010,1,5000);
insert into percent_rank_tab values(2010,2,6000);
insert into percent_rank_tab values(2010,3,7000);

select years,months,amount from percent_rank_tab;
select years,months,amount,percent_rank() over(order by amount) from percent_rank_tab;
select years,months,amount,percent_rank() over(order by amount nulls first ) from percent_rank_tab;
select years,months,amount,percent_rank() over(partition by years order by amount) from percent_rank_tab;
select years,months,amount,percent_rank() over(partition by years,months order by amount) from percent_rank_tab;

select * from percent_rank_tab;
drop table percent_rank_tab;


drop table percent_rank_tab;

DROP TABLE IF EXISTS empsalary;
CREATE TABLE empsalary(
  depname varchar,
  empno bigint,
  salary int,
  enroll_date date
);
INSERT INTO empsalary VALUES('develop',10, 5200, '08/01/2007');
INSERT INTO empsalary VALUES('sales', 1, 5000, '10/01/2006');
INSERT INTO empsalary VALUES('personnel', 5, 3500, '12/10/2007');
INSERT INTO empsalary VALUES('sales', 4, 4800, '08/08/2007');
INSERT INTO empsalary VALUES('sales', 6, 5500, '01/02/2007');
INSERT INTO empsalary VALUES('personnel', 2, 3900, '12/23/2006');
INSERT INTO empsalary VALUES('develop', 7, 4200, '01/01/2008');
INSERT INTO empsalary VALUES('develop', 9, 4500, '01/01/2008');
INSERT INTO empsalary VALUES('sales', 3, 4800, '08/01/2007');
INSERT INTO empsalary VALUES('develop', 8, 6000, '10/01/2006');
INSERT INTO empsalary VALUES('develop', 11, 5200, '08/15/2007');

select * from empsalary ;


select sum(salary) OVER (PARTITION BY depname),avg(salary) OVER (PARTITION BY depname),depname,empno,salary,enroll_date  from empsalary;

select sum(salary) OVER (PARTITION BY depname),avg(salary) OVER (PARTITION BY depname),percent_rank() over(partition by depname order by salary desc),depname,empno,salary,enroll_date  from empsalary;

select percent_rank() over(partition by depname order by salary desc),depname,empno,salary,enroll_date from empsalary;

select percent_rank() over(partition by enroll_date order by salary desc),depname,empno,salary,enroll_date from empsalary;

DROP TABLE IF EXISTS empsalary;
