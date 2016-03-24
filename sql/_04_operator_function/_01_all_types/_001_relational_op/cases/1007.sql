--test  set with comparison operators like '=','>','<' etc in where clause and cast function 

create class func_01 ( a set of int, b multiset of int , c list of int );
insert into func_01 values ( {},{},{});
insert into func_01 values ( null,null,null);
insert into func_01 values ( {1,1},{1,1},{1,1});
insert into func_01 values ( {1,2,3},{1,2,3},{1,2,3});
insert into func_01 values ( {-1,-2,-3},{-1,-2,-3},{-1,-2,-3});

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
select b, c from func_01 where b = c order by 1,2;	
select b, c from func_01 where b > c order by 1,2;	
select b, c from func_01 where b < c order by 1,2;	
select b, c from func_01 where b <> c order by 1,2;	
select b, c from func_01 where b <= c order by 1,2;	
select b, c from func_01 where b >= c order by 1,2;	
select a, a from func_01 where a = a order by 1,2;	
select b, b from func_01 where b = b order by 1,2;	
select c, c from func_01 where c = c order by 1,2;	
select a, a from func_01 where a <> a order by 1,2;	
select b, b from func_01 where b <> b order by 1,2;	
select c, c from func_01 where c <> c order by 1,2;	
select a, c from func_01 where cast(a as list of int) >= c order by 1,2;	
select a, c from func_01 where a >= cast(c as set of int ) order by 1,2;

drop func_01 ;
