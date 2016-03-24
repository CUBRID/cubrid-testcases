-- Display Query plan,create class(atrribute null),insert data into class,retrieve class using group by, order by and orderby_num()

create class xoo ( a int not null, b varchar(3) not null, c int not null, d int not null, order_no int);
insert into xoo values(5, '3', 1, 2, 1);
insert into xoo values(4, '7', 2, 1, 2);
insert into xoo values(6, '8', 5, 9, 3);
insert into xoo values(1, '2', 7, 8, 4);
insert into xoo values(7, '6', 6, 3, 5);
insert into xoo values(3, '9', 3, 4, 6);
insert into xoo values(8, '1', 9, 5, 7);
insert into xoo values(2, '4', 4, 6, 8);
insert into xoo values(9, '5', 8, 7, 9);

insert into xoo values(10, '1', 5, 5, 10);
insert into xoo values(10, '6', 3, 1, 11);
insert into xoo values(10, '4', 9, 5, 12);
insert into xoo values(10, '4', 6, 5, 13);
insert into xoo values(10, '15', 3, 5, 14);
insert into xoo values(10, '4', 5, 5, 15);
insert into xoo values(10, '4', 2, 1, 16);
insert into xoo values(10, '4', 1, 5, 17);
insert into xoo values(10, '4', 9, 5, 18);

create index idx on xoo (a,b,c);

select /*+ RECOMPILE */  count(*), a,b,c from xoo
group by a,b,c 
order by a,b,c for orderby_num() < 15;

select /*+ RECOMPILE */  count(*), a,b,c from xoo
group by a,b,c 
order by a,b for orderby_num() < 15;

select /*+ RECOMPILE */  count(*), a,b,c from xoo
group by a,b,c 
order by a for orderby_num() < 15;

select /*+ RECOMPILE */  count(*), a from xoo
group by a 
order by a for orderby_num() < 7;

select /*+ RECOMPILE */  count(*), a,b,c from xoo
group by a,b,c
order by c for orderby_num() < 15;

select /*+ RECOMPILE */  count(*), a,b,c from xoo
group by a,b,c 
order by -a, b for orderby_num() < 15;

select /*+ RECOMPILE */  count(*), a,b,c from xoo
group by a,b,c 
order by c,b,a for orderby_num() < 15;




select /*+ RECOMPILE */  count(*), a,b,c from xoo
where a <> 10
group by a,b,c
order by a,b,c for orderby_num() < 15;

select /*+ RECOMPILE */  count(*), a,b,c from xoo
where a = 10 and b< '90'
group by a,b,c
order by a,b,c for orderby_num() < 15;

select /*+ RECOMPILE */  count(*), a,b,c from xoo
where a = 10 and b = '4' and c < 10
group by a,b,c
order by a,b,c for orderby_num() < 15;

select /*+ RECOMPILE */  count(*), a,b,c from xoo
where a < 10 and c = 4
group by a,b,c
order by a,b,c for orderby_num() < 15;

select /*+ RECOMPILE */  count(*), a,b,c from xoo
where b = '4'
group by a,b,c
order by b,c for orderby_num() < 15;

select /*+ RECOMPILE */  count(*), a,b,c from xoo
where b = '4' and c =9
group by a,b,c
order by a,c for orderby_num() < 15;

select /*+ RECOMPILE */  count(*), a from xoo
where a < 10
group by a
order by a for orderby_num() < 15;


select /*+ RECOMPILE */  x1.a, x2.a, x2.b, count(*)
from xoo x1, xoo x2
where x1.a = x2.a
group by x1.a, x2.a, x2.b
order by 1,2,3 ;

select /*+ RECOMPILE */  x1.a, x2.a, x2.b, count(*)
from xoo x1, xoo x2
where x1.a = x2.a
group by x1.a, x2.a, x2.b 
order by 1,2,3 for orderby_num() < 10;


select /*+ RECOMPILE */  x1.a, x2.a, x2.b, count(*)
from xoo x1, xoo x2
where x1.a = x2.a and x1.a < 12
group by x1.a, x2.a, x2.b
order by 1,2 ;

select /*+ RECOMPILE */  x1.a, x2.a, x2.b, count(*)
from xoo x1, xoo x2
where x1.a = x2.a and x1.a < 12 and x2.a < 12
group by x1.a, x2.a, x2.b
order by 1,2,3; 


select /*+ RECOMPILE */  x1.a, x2.a, x2.b, count(*)
from xoo x1, xoo x2
where x1.a = x2.a and x1.a = 10 and x2.a < 12
group by x1.a, x2.a, x2.b
order by 1,2,3 ;

select /*+ RECOMPILE */  x1.a, x2.a, x2.b, count(*)
from xoo x1, xoo x2
where x1.a = x2.a and x1.a = 10 and x1.a = 10 and x1.a <= 12
group by x1.a, x2.a, x2.b
order by 1,2,3 ;

select /*+ RECOMPILE */  x1.a, x2.a, x2.b, count(*)
from xoo x1, xoo x2
where x1.a = x2.a and x1.a = 10 and x1.a = 10 and x1.c <= 12 and x2.a = 10
group by x1.a, x2.a, x2.b
order by 1,2,3 ;

select /*+ RECOMPILE */  count(*), a,b,(select /*+ RECOMPILE */  c from xoo xx order by xx.order_no asc for orderby_num() =1 ) xx 
from xoo group by a,b order by a,b;

select /*+ RECOMPILE */  count(*), a,b,(select /*+ RECOMPILE */  c from xoo xx order by xx.order_no asc for orderby_num() = 1 ) xx 
from xoo 
where a <= 10 group by a,b order by a,b;

select /*+ RECOMPILE */  count(*), a,b,(select /*+ RECOMPILE */  y.c from xoo y order by y.order_no asc for orderby_num() = 1 ) xx 
from xoo 
group by a,b,4 order by a,b,xx;

select /*+ RECOMPILE */  count(*), a,b,(select /*+ RECOMPILE */  y.c from xoo y order by y.order_no asc for orderby_num() = 1 ) xx 
from xoo 
where a <= 11 group by a,b,4 order by a,b,xx;


select /*+ RECOMPILE */  count(*), a,b,c from xoo
where a = 10 and b = '4' and c < 10
group by a,b,c
order by a,b,4 for orderby_num() < 15;

select /*+ RECOMPILE */  count(*), a,b,c from xoo
group by a,b,c
order by a,b,4 for orderby_num() < 15;

select /*+ RECOMPILE */  count(*), a,b,c from xoo where a < 11
group by a,b,c
order by a,b,4 for orderby_num() < 15;

select /*+ RECOMPILE */  a,b, count(*) from xoo group by a,b;

select /*+ RECOMPILE */  a,b from xoo union select /*+ RECOMPILE */  a,b from xoo;
select /*+ RECOMPILE */  a,b from xoo difference select /*+ RECOMPILE */  a,b from xoo;
select /*+ RECOMPILE */  a,b from xoo intersection select /*+ RECOMPILE */  a,b from xoo;

select /*+ RECOMPILE */  a,b from ( select /*+ RECOMPILE */  a,b,order_no from xoo order by order_no asc) x order by order_no asc;
select /*+ RECOMPILE */  (select /*+ RECOMPILE */ a from xoo order by a asc for orderby_num() = 1 ) c1 , b  from xoo x order by order_no asc;
select /*+ RECOMPILE */  (select /*+ RECOMPILE */ a from xoo order by b asc,a asc for orderby_num() = 1 ) c1 , b  from xoo x order by order_no asc;
select /*+ RECOMPILE */  (select /*+ RECOMPILE */ a from xoo order by order_no asc for orderby_num() = 1 ) c1 , b  from xoo x order by order_no asc;

drop xoo;
