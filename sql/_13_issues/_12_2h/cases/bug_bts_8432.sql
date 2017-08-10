--TEST: [Analytic Functions] ROWNUM result is not correct when used with ROW_NUMBER() function

drop table if exists z1;

create table z1 (a int, b int);
insert into z1 values (1,1);
insert into z1 values (1,2);

--rownum with columns
select rownum, a,b from z1;

--test: rownum with analytic functions
select rownum, a,b, ROW_NUMBER() over() c11 from z1 order by 1, 2, 3;
select rownum, a,b, ROW_NUMBER() over(ORDER BY b asc) c11 from z1 order by 1, 2, 3;
select rownum, a,b, ROW_NUMBER() over(PARTITION BY a+b) c11 from z1 order by 1, 2, 3;
select rownum, a,b, ROW_NUMBER() over(PARTITION BY a+b ORDER BY b asc) c11 from z1 order by 1, 2, 3;


drop table z1;
