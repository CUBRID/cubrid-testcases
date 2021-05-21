drop if exists foo,yoo;
create table foo(a varchar);
insert into foo values('0:12:23');
insert into foo values('23:34:45');
insert into foo values(NULL);
create table yoo as 
WITH cte AS 
(
select width_bucket(a, '0:0:0', '23:59:59', 3) as [width_bucket(foo.a, '0:0:0', '23:59:59',  cast(3 as double))] from foo order by 1
)
select * from cte;
select * from yoo order by 1;
drop if exists foo,yoo;
