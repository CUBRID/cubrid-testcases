drop table if exists tbl,foo;
CREATE TABLE tbl(id int auto_increment,a TIME, b DATE, c TIMESTAMP, d DATETIME);
INSERT INTO tbl(a,b,c,d) VALUES('13:10:10', '2008-10-1', '2008-10-1 13:10:10', '2008-10-1 13:10:10');

create table foo as
with cte(a) as
(
SELECT TO_CHAR(b, 'DD, DY , MON, YYYY') FROM tbl
) select * from cte;

insert into foo
with cte as
(
 SELECT TO_CHAR(c, 'HH24:MI, DD, MONTH, YYYY') FROM tbl
) select * from cte;

insert into foo
with cte as
(
 SELECT TO_CHAR(d, 'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY') FROM tbl
) select * from cte;

insert into foo
with cte as
(
 SELECT TO_CHAR(TIMESTAMP'2009-10-04 22:23:00', 'Day Month yyyy')
) select * from cte;

replace into foo
with cte as
(
  SELECT TO_CHAR(TIMESTAMP'2009-10-04 22:23:00', 'Day Month yyyy','ko_KR')
) select * from cte;
select * from foo order by 1;
insert into foo
with cte as
(
 SELECT TO_CHAR(TIMESTAMP'2009-10-04 22:23:00', 'Day Month yyyy','tr_TR')
) select * from cte;
insert into foo
with cte as
(
 SELECT TO_CHAR(TIMESTAMP'2009-10-04 22:23:00', 'Day Month yyyy','de_DE')
) select * from cte;
insert into foo
with cte as
(
 SELECT TO_CHAR(timestamp '0000-00-00 00:00:00', 'Month Day YYYY')
) select * from cte;
insert into foo
with cte as
(
 SELECT TO_CHAR(datetimetz'2001-10-11 02:03:04 AM Europe/Bucharest EEST')
)select * from cte;
insert into foo
with cte as
(
 SELECT TO_CHAR(datetimetz'2001-10-11 02:03:04 AM Europe/Bucharest EEST', 'MM/DD/YYYY HH24:MI TZR TZD TZH TZM')
) select * from cte;
insert into foo
with cte as
(
  SELECT TO_CHAR(12345,'S999999')
  union all
  select TO_CHAR(12345,'S099999')
)select * from cte;
insert into foo
with cte as
(
 SELECT TO_CHAR(1234567,'9,999,999,999')
)select * from cte;
insert into foo
with cte as
(
  SELECT TO_CHAR(1234567,'9.999.999.999')
)select * from cte;

insert into foo
with cte as
(
 SELECT TO_CHAR(123.4567,'99') 
 union all 
 select  TO_CHAR(123.4567,'999.99999') 
 union all 
 select TO_CHAR(123.4567,'99999.999')
)select * from cte;
select * from foo order by 1;


with cte as
(
 SELECT TO_CHAR(123.4567,'99')
 union all
 select  TO_CHAR(123.4567,'999.99999')
 union all
 select TO_CHAR(123.4567,'99999.999')
)delete from foo
 where a in (select * from cte);
select * from foo order by 1;

with cte as
(
  SELECT TO_CHAR(1234567,'9.999.999.999')
) update foo,cte set a='updated' where a in (select * from cte);
select count(*) from foo where a='updated';

drop table if exists foo,tbl;
