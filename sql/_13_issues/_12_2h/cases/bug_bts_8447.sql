--TEST: [Analytic Functions] PARTITION BY constant string literals should be supported


drop table if exists z2;

create table z2 (a int, b int);
insert into z2 values (1,1);
insert into z2 values (1,2);

SELECT a, b, row_number() over (partition by 'A' order by b) c11 FROM z2 order by c11;
SELECT a, b, row_number() over (partition by "A" order by b) c11 FROM z2 order by c11;
SELECT a, b, row_number() over (partition by a order by 'abc') c11 FROM z2 order by c11;


select a, count(*) over(partition by "aBc") from z2 order by 2;
select a, count(*) over(partition by "aBc" order by b) from z2 order by 2;
select a, count(*) over(order by [aBc]) from z2 order by 2;
select a, count(*) over(partition by [aBc] order by {abc}) from z2 order by 2;


drop table z2;
