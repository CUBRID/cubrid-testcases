--TEST: [Analytic Functions] 'ERROR: System error (generate inst_num or orderby_num) in ../../src/parser/xasl_generation.c (line: 6885)' occurs when using 'order by rownum' in the over() clause.


drop table if exists foo;

create table foo(a int);
insert into foo values(1);
insert into foo values(1);
insert into foo values(2);
insert into foo values(2);
insert into foo values(3);

--system error occurs
select a, rank() over(order by rownum) from foo order by 1;
select a, rank() over(partition by a order by rownum) from foo order by 1;
select a, rank() over(partition by rownum) from foo order by 1;
select a, rank() over(partition by rownum order by rownum) from foo order by 1;
select a, rank() over(order by SYSDATETIME) from foo order by 1;
select a, rank() over(partition by SYSTIMESTAMP order by SYSDATETIME) from foo order by 1;
select a, rank() over(order by a, SYSDATETIME, rownum) from foo order by 1;
select a, rank() over(partition by SYSDATE, UNIX_TIMESTAMP()) from foo order by 1;


drop table foo;
