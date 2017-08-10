--test left outer join, right outer join using in, not in clauses
--it tests left outer join, right outer join using in, not in clauses

create table DML_0001 ( a int, b char(10) );
create table DML_0002 ( a int, b char(10) );

create table DML_0003 under DML_0001 ( c int );
create table DML_0004 under DML_0003 ( d int );
create table DML_0005 under DML_0004 ( e int );

create table DML_0006 under DML_0002 ( c int );
create table DML_0007 under DML_0006 ( d int );
create table DML_0008 under DML_0007 ( e int );

create table DML_0009 ( a set of int , b multiset of int, c list of int);

create table DML_0010 ( a int, b char(10) );
create table DML_0011 ( a int, b char(10) );
insert into DML_0001 values(null, 'aaa1');
insert into DML_0001 values(1, 'aaa2');
insert into DML_0001 values(2, 'aaa3');
insert into DML_0001 values(3, 'oooo');

insert into DML_0002 values (null, 'bbb1');
insert into DML_0002 values (1, 'bbb2');
insert into DML_0002 values (2, 'bbb3');
insert into DML_0002 values (5, 'oooo');

insert into DML_0010 values(null, 'ddd1');
insert into DML_0010 values(1, 'ddd2');
insert into DML_0010 values(2, 'ddd3');
insert into DML_0010 values(7, 'oooo');

insert into DML_0011 values (null, 'eee1');
insert into DML_0011 values (1, 'eee2');
insert into DML_0011 values (2, 'eee3');
insert into DML_0011 values (9, 'oooo');



insert into DML_0003 (a,b,c) values ( 10, 'DML_0003', 10 );
insert into DML_0003 (a,b,c) values ( 20, 'DML_0003', null);
insert into DML_0003 (a,b,c) values (null, null, null);
insert into DML_0003 (a,b,c) values ( 30, 'ooo', 30);


insert into DML_0004 (a,b,c,d) values ( 100, 'DML_0004', 100, 200);
insert into DML_0004 (a,b,c,d) values ( null, 'DML_0004', 100, 200 );
insert into DML_0004 (a,b,c,d) values ( null, null, null, null );
insert into DML_0004 (a,b,c,d) values ( 300, 'ooo', 100, 200);

insert into DML_0005 (a,b,c,d,e) values ( 1000, 'DML_0005', 1000, 2000,3000);
insert into DML_0005 (a,b,c,d,e) values ( null, 'DML_0005', 1000, 2000,3000);
insert into DML_0005 (a,b,c,d,e) values ( null, null, null, null, null);

insert into DML_0006 (a,b,c) values ( 10, 'DML_0006', 10 );
insert into DML_0006 (a,b,c) values ( 20, 'DML_0006', null);
insert into DML_0006 (a,b,c) values (null, null, null);
insert into DML_0006 (a,b,c) values ( 30, 'ooo', 30);

insert into DML_0007 (a,b,c,d) values ( 100, 'DML_0007', 100, 200);
insert into DML_0007 (a,b,c,d) values ( null, 'DML_0007', 100, 200 );
insert into DML_0007 (a,b,c,d) values ( null, null, null, null );
insert into DML_0007 (a,b,c,d) values ( 300, 'ooo', 100, 200);

insert into DML_0008 (a,b,c,d,e) values ( 1000, 'DML_0008', 1000, 2000,3000);
insert into DML_0008 (a,b,c,d,e) values ( null, 'DML_0008', 1000, 2000,3000);
insert into DML_0008 (a,b,c,d,e) values ( null, null, null, null, null);


insert into DML_0009 values ({1,2,3,4,5,6,7,8,9,0,9,8,7,6,5,4,3,2,1,null},
{1,2,3,4,5,6,7,8,9,0,9,8,7,6,5,4,3,2,1,null},
{1,2,3,4,5,6,7,8,9,0,9,8,7,6,5,4,3,2,1,null});
select DML_0001.a  , DML_0002.b from DML_0001 LEFT JOIN ( select a,b from DML_0002 ) as DML_0002(a,b)
on  DML_0001.b=DML_0002.b 
RIGHT OUTER JOIN DML_0001 DML_0009 on DML_0001.a is null
order by 1,2;

select DML_0001.a  , DML_0002.b from DML_0001 LEFT JOIN ( select a,b from DML_0002 ) as DML_0002(a,b)
on  DML_0001.b=DML_0002.b 
RIGHT OUTER JOIN DML_0001 DML_0009 on DML_0001.a is null
where DML_0001.a is null and DML_0002.a is null
order by 1,2;

select DML_0001.a  , DML_0002.b from DML_0001 LEFT JOIN ( select a,b from DML_0002 ) as DML_0002(a,b)
on  DML_0001.b=DML_0002.b 
RIGHT OUTER JOIN DML_0001 DML_0009 on DML_0001.a is null
where DML_0001.a is not null and DML_0002.a is null
order by 1,2;

select DML_0001.a  , DML_0002.b 
from (select a,b from DML_0001 ) as DML_0001(a,b)
  LEFT JOIN ( select a,b from DML_0002 where a in (1) ) as DML_0002(a,b)
  on  DML_0001.b=DML_0002.b and DML_0001.a < DML_0001.a * DML_0002.a
  RIGHT OUTER JOIN (select a,b from DML_0001 DML_0010 where DML_0010.a in (1,2) ) as  DML_0009(a,b) on DML_0001.a is null
order by 1,2;

select t1.a, t2.a, t3.a, t4.a, t5.a, t6.a, t7.a, t8.a 
from DML_0001 t1 RIGHT JOIN DML_0002 t2 on t1.a = t2.a or t1.a is null
RIGHT JOIn DML_0001 t3 on t1.a > 1
LEFT OUTER JOIN DML_0002 t4 on t2.a <= 3
LEFT OUTER JOIN DML_0001 t5 on t1.b is not null
RIGHT OUTER JOIN DML_0002 t6 on t6.b is not null or t2.b is not null
LEFT OUTER JOIN DML_0001 t7 on t7.a in (1,2,3,4,5,null) 
RIGHT OUTER JOIN DML_0002 t8 on t6.b not in ( 'ooo' )
where t3.a is not null and t4.a is not null and t5.a is not null and t6.a is not null  and t8.a is null
order by 1,2,3,4,5,6,7,8;

select t1.a, t2.a, t3.a, t4.a, t5.a, t6.a, t7.a, t8.a
from DML_0001 t1 RIGHT JOIN DML_0002 t2 on t1.a = t2.a or t1.a is null
RIGHT JOIn DML_0001 t3 on t1.a >=3
LEFT OUTER JOIN DML_0002 t4 on t2.a <= 3
LEFT OUTER JOIN DML_0001 t5 on t1.b is not null
RIGHT OUTER JOIN DML_0002 t6 on t6.b is not null and  t2.b is not null
LEFT OUTER JOIN DML_0001 t7 on t7.a in (1,2,3,4,5,null) 
RIGHT OUTER JOIN DML_0002 t8 on t6.b not in ( 'ooo' )
order by 1,2,3,4,5,6,7,8;

select t1.a, t2.a, t3.a, t4.a, t5.a, t6.a, t7.a, t8.a 
from DML_0001 t1 RIGHT JOIN DML_0002 t2 on t1.a = t2.a or t1.a is null
RIGHT JOIn DML_0001 t3 on t1.a >=3
LEFT OUTER JOIN (select  *  from DML_0002 ) as  t4(a,b) on t2.a <= 3
LEFT OUTER JOIN DML_0001 t5 on t1.b is not null
RIGHT OUTER JOIN DML_0002 t6 on t6.b is not null and  t2.b is not null
LEFT OUTER JOIN DML_0001 t7 on t7.a in (1,2,3,4,5,null)
RIGHT OUTER JOIN DML_0002 t8 on t6.b not in ( 'ooo' )
order by 1,2,3,4,5,6,7,8;


drop class DML_0001;
drop class DML_0002;
drop class DML_0003;
drop class DML_0004;
drop class DML_0005;
drop class DML_0006;
drop class DML_0007;
drop class DML_0008;
drop class DML_0009;
drop class DML_0010;
drop class DML_0011;
