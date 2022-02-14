autocommit off;
create table aa ( a int, b char(10) );
create table bbb ( a int, b char(10) );
create table aa1 under aa ( c int );
create table aa2 under aa1 ( d int );
create table aa3 under aa2 ( e int );
create table bb1 under bbb ( c int );
create table bb2 under bb1 ( d int );
create table bb3 under bb2 ( e int );
create table cc ( a set of int , b multiset of int, c list of int);
insert into aa values(null, 'aaa1');
insert into aa values(1, 'aaa2');
insert into aa values(2, 'aaa3');
insert into aa values(3, 'oooo');
insert into bbb values (null, 'bbb1');
insert into bbb values (1, 'bbb2');
insert into bbb values (2, 'bbb3');
insert into bbb values (5, '0000');
insert into aa1 (a,b,c) values ( 10, 'aa1', 10 );
insert into aa1 (a,b,c) values ( 20, 'aa1', null);
insert into aa1 (a,b,c) values (null, null, null);
insert into aa1 (a,b,c) values ( 30, 'ooo', 30);
insert into aa2 (a,b,c,d) values ( 100, 'aa2', 100, 200);
insert into aa2 (a,b,c,d) values ( null, 'aa2', 100, 200 );
insert into aa2 (a,b,c,d) values ( null, null, null, null );
insert into aa2 (a,b,c,d) values ( 300, 'ooo', 100, 200);
insert into aa3 (a,b,c,d,e) values ( 1000, 'aa3', 1000, 2000,3000);
insert into aa3 (a,b,c,d,e) values ( null, 'aa3', 1000, 2000,3000);
insert into aa3 (a,b,c,d,e) values ( null, null, null, null, null);
insert into bb1 (a,b,c) values ( 10, 'bb1', 10 );
insert into bb1 (a,b,c) values ( 20, 'bb1', null);
insert into bb1 (a,b,c) values (null, null, null);
insert into bb1 (a,b,c) values ( 30, 'ooo', 30);
insert into bb2 (a,b,c,d) values ( 100, 'bb2', 100, 200);
insert into bb2 (a,b,c,d) values ( null, 'bb2', 100, 200 );
insert into bb2 (a,b,c,d) values ( null, null, null, null );
insert into bb2 (a,b,c,d) values ( 300, 'ooo', 100, 200);
insert into bb3 (a,b,c,d,e) values ( 1000, 'bb3', 1000, 2000,3000);
insert into bb3 (a,b,c,d,e) values ( null, 'bb3', 1000, 2000,3000);
insert into bb3 (a,b,c,d,e) values ( null, null, null, null, null);
insert into cc values ({1,2,3,4,5,6,7,8,9,0,9,8,7,6,5,4,3,2,1,null},
{1,2,3,4,5,6,7,8,9,0,9,8,7,6,5,4,3,2,1,null},
{1,2,3,4,5,6,7,8,9,0,9,8,7,6,5,4,3,2,1,null});

select aa.a, aa.b, bb.a, bb.b from aa left outer join bbb bb on aa.a = bb.a and aa.b=bb.b order by 1,2,3,4 ;
select aa.a, aa.b, bb.a, bb.b from aa LEFT OUTER JOIN bbb bb on aa.a = bb.a and aa.b=bb.b order by 1,2,3,4 ;
select aa.a, aa.b, bb.a, bb.b from aa left  join bbb bb on aa.a = bb.a and aa.b=bb.b order by 1,2,3,4 ;
select aa.a, aa.b, bb.a, bb.b from aa LEFT  JOIN bbb bb on aa.a = bb.a and aa.b=bb.b order by 1,2,3,4 ;
select aa.a, aa.b, bb.a, bb.b from aa right outer join bbb bb on aa.a = bb.a and aa.b=bb.b order by 1,2,3,4 ;
select aa.a, aa.b, bb.a, bb.b from aa RIGHT OUTER JOIN bbb bb on aa.a = bb.a and aa.b=bb.b order by 1,2,3,4 ;
select aa.a, aa.b, bb.a, bb.b from aa right join bbb bb on aa.a = bb.a and aa.b=bb.b order by 1,2,3,4 ;
select aa.a, aa.b, bb.a, bb.b from aa RIGHT JOIN bbb bb on aa.a = bb.a and aa.b=bb.b order by 1,2,3,4 ;
select aa.a, bb.b from aa LEFT OUTER JOIN bbb bb on aa.a is null and bb.a is null order by 1,2 ;
select aa.a, bb.b from aa LEFT OUTER JOIN bbb bb on aa.a is null and bb.a is null and aa.a=bb.a order by 1,2 ;
select aa.a, bb.b from aa LEFT OUTER JOIN bbb bb on aa.a is null and bb.a is not null order by 1,2 ;
select aa.a, bb.b from aa LEFT OUTER JOIN bbb bb on aa.a = 1 order by 1,2  ;
select aa.a, bb.b from aa LEFT OUTER JOIN bbb bb on aa.a > 1 order by 1,2  ;
 
select aa.a, bb.b from aa LEFT OUTER JOIN bbb bb on aa.a in (1,2,3,4) and aa.a< bb.a order by 1,2 ;
select aa.a, bb.b from aa LEFT OUTER JOIN bbb bb on aa.a not in (1,2) and aa.a< bb.a order by 1,2 ;
select aa.a, bb.b from aa LEFT OUTER JOIN bbb bb on aa.a = 1 and aa.a=bb.a and aa.a=1 order by 1,2 ;
 
select aa.a, bb.b from aa LEFT OUTER JOIN bbb bb on aa.a > 1 and bb.a > 1 order by 1,2 ;
select aa.a, bb.b from aa LEFT OUTER JOIN bbb bb on (aa.a + 2) > 3 -1 and (bb.a * 2) > 1 order by 1,2 ;
select aa.a, bb.b from aa LEFT OUTER JOIN bbb bb 
on (aa.a + 2) > 3 -1 and (bb.a * 2) > 1 where aa.a is not null order by 1,2  ;
select aa.a, bb.b from aa RIGHT OUTER JOIN bbb bb on aa.a is null and bb.a is null order by 1,2 ;
select aa.a, bb.b from aa RIGHT OUTER JOIN bbb bb on aa.a is null and bb.a is null and aa.a=bb.a order by 1,2 ;
select aa.a, bb.b from aa RIGHT OUTER JOIN bbb bb on aa.a is null and bb.a is not null order by 1,2 ;
select aa.a, bb.b from aa RIGHT OUTER JOIN bbb bb on aa.a = 1 order by 1,2 ;
select aa.a, bb.b from aa RIGHT OUTER JOIN bbb bb on aa.a > 1 order by 1,2 ;
select aa.a, bb.b from aa RIGHT OUTER JOIN bbb bb on aa.a in (1,2,3,4) and aa.a< bb.a order by 1,2 ;
select aa.a, bb.b from aa RIGHT OUTER JOIN bbb bb on aa.a not in (1,2) and aa.a< bb.a order by 1,2 ;
select aa.a, bb.b from aa RIGHT OUTER JOIN bbb bb on aa.a = 1 and aa.a=bb.a and aa.a=1 order by 1,2 ;
select aa.a, bb.b from aa RIGHT OUTER JOIN bbb bb on aa.a > 1 and bb.a > 1 order by 1,2 ;
select aa.a, bb.b from aa RIGHT OUTER JOIN bbb bb on (aa.a + 2) > 3 -1 and (bb.a * 2) > 1 order by 1,2 ;
select aa.a, bb.b from aa RIGHT OUTER JOIN bbb bb 
on (aa.a + 2) > 3 -1 and (bb.a * 2) > 1 where aa.a is not null order by 1,2 ;
 
select * from aa LEFT JOIN ( select a,b from bbb ) as bb(a,b) 
on aa.a=bb.a and aa.b=bb.b  order by 1, 2;
select * from (select a,b from aa) as aa(a,b) LEFT JOIN ( select a,b from bbb ) as bb(a,b) 
on aa.a=bb.a and aa.b=bb.b  order by 1, 2;
select * from (select a,b from aa where a>1) as aa(a,b) LEFT JOIN ( select a,b
from bbb where a <3 ) as bb(a,b) 
on aa.a=bb.a and aa.b=bb.b  order by 1, 2;
 
select aa.a, bb.b from aa LEFT OUTER JOIN bbb bb on to_char(bb.a) is not null order by 1,2;

select aa.a, bb.b from aa LEFT OUTER JOIN bbb bb on to_char(bb.a)='1' order by 1,2;
select aa.a, aa.b, bb.a, bb.b from all aa right outer join all bbb bb 
on aa.a = bb.a and aa.b=bb.b and bb.a is not null  order by 1,2,3,4;

select   tt.a, aa.a from (select tt.a from cc,table(a) as tt(a)) as tt(a) LEFT JOIN aa on tt.a = aa.a order by 1,2;
select   tt.a, aa.a from (select tt.a from cc,table(b) as tt(a)) as tt(a) LEFT JOIN aa on tt.a = aa.a order by 1,2;
select   tt.a, aa.a from (select tt.a from cc,table(c) as tt(a)) as tt(a) LEFT JOIN aa on tt.a = aa.a order by 1,2;
select   t1.a, t2.a from (select t1.a from cc,table(a) as t1(a)) as t1(a)
LEFT JOIN
(select t2.a from cc,table(b) as t2(a)) as t2(a) 
on t1.a = t2.a and t1.a > 5 order by 1,2;

rollback;
