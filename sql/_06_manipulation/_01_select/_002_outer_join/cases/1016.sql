--test  LEFT JOIN, LEFT OUTER JOIN using some select statements

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

select DML_0001.a, DML_0002.b from DML_0001 LEFT JOIN ( select a,b from DML_0002 ) as DML_0002(a,b) 
on DML_0001.a=DML_0002.a and DML_0001.b=DML_0002.b  order by 1,2;

select DML_0001.a, DML_0002.a from (select a,b from DML_0001) as DML_0001(a,b) LEFT JOIN ( select a,b from DML_0002 ) as DML_0002(a,b) 
on DML_0001.a=DML_0002.a and DML_0001.b=DML_0002.b  order by 1,2;

select DML_0001.a, DML_0002.a from (select a,b from DML_0001 where a>1) as DML_0001(a,b) LEFT JOIN
 ( select a,b from DML_0002 where DML_0002.a <3 ) as DML_0002(a,b) 
on DML_0001.a=DML_0002.a and DML_0001.b=DML_0002.b order by 1,2 ;
 
select DML_0001.a, DML_0002.a, DML_0010.a, DML_0011.a from (select a,b from DML_0001 where a>1) as DML_0001(a,b) LEFT JOIN
( select a,b from DML_0002 where DML_0002.a <3 ) as DML_0002(a,b) 
on DML_0001.a=DML_0002.a and DML_0001.b=DML_0002.b 
LEFT OUTER JOIN ( select a,b from DML_0010 ) as DML_0010(a,b) on DML_0010.a >= 1
LEFT OUTER JOIN ( select a,b from DML_0011 ) as DML_0011(a,b) on DML_0011.a between 2 and 5 and DML_0011.a = DML_0010.a
order by 1,2,3,4 ;

select DML_0001.a  , DML_0002.b from DML_0001 LEFT JOIN DML_0002
on  DML_0001.b=DML_0002.b and DML_0001.a < DML_0001.a *DML_0002.a
LEFT OUTER JOIN ( select a,b from DML_0002 where a in (1) ) as DML_0009(a,b)  on DML_0001.a is null
order by 1,2 ;


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
