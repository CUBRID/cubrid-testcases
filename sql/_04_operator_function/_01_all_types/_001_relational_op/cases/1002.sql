--test numeric data type by comparing operators like '=','>','<' in where clause and  plus(+) symbol in select clause

create class func_01 ( a smallint, b int, c numeric(38,10), d float, e monetary, f double );
insert into func_01 values ( 0,0,0,0,0,0);
insert into func_01(a) values ( null);
insert into func_01 values ( 1,1,1,1,1,1);
insert into func_01 values ( 127,10000,987654321.123456789,987654321.123,987654321.987,987654321.123);
insert into func_01 values (-127,-10000,-987654321.123456789,-987654321.123, -987654321.987,-987654321.123);

select a, b from func_01 where a = b order by 1,2;	
select a, b from func_01 where a > b order by 1,2;	
select a, b from func_01 where a < b order by 1,2;	
select a, b from func_01 where a <> b order by 1,2;	
select a, b from func_01 where a <= b order by 1,2;	
select a, b from func_01 where a >= b order by 1,2;	
select a, c from func_01 where a = c order by 1,2;	
select a, c from func_01 where a > c order by 1,2;	
select a, c from func_01 where a < c order by 1,2;	
select a, c from func_01 where a <> c order by 1,2;	
select a, c from func_01 where a <= c order by 1,2;	
select a, c from func_01 where a >= c order by 1,2;	
select a, d from func_01 where a = d order by 1,2;	
select a, d from func_01 where a > d order by 1,2;	
select a, d from func_01 where a < d order by 1,2;	
select a, d from func_01 where a <> d order by 1,2;	
select a, d from func_01 where a <= d order by 1,2;	
select a, d from func_01 where a >= d order by 1,2;	
select a, e from func_01 where a = e order by 1,2;	
select a, e from func_01 where a > e order by 1,2;	
select a, e from func_01 where a < e order by 1,2;	
select a, e from func_01 where a <> e order by 1,2;	
select a, e from func_01 where a <= e order by 1,2;	
select a, e from func_01 where a >= e order by 1,2;	
select a, f from func_01 where a = f order by 1,2;	
select a, f from func_01 where a > f order by 1,2;	
select a, f from func_01 where a < f order by 1,2;	
select a, f from func_01 where a <> f order by 1,2;	
select a, f from func_01 where a <= f order by 1,2;	
select a, f from func_01 where a >= f order by 1,2;	
select a+b, a+f from func_01 where a = f order by 1,2;	
select a+b, a+f from func_01 where a > f order by 1,2;	
select a+b, a+f from func_01 where a < f order by 1,2;	
select a+b, a+f from func_01 where a <> f order by 1,2;	
select a+b, a+f from func_01 where a <= f order by 1,2;	
select a+b, a+f from func_01 where a >= f order by 1,2;

drop class func_01;
