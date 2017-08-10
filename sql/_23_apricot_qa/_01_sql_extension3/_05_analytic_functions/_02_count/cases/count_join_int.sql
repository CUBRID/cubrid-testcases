--combination with join statements



create table md_int1(id1 int not null, col1 char(20));
insert into md_int1 values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into md_int1 values(1, 'fff'), (2, 'eee'), (3, 'ddd'), (4, 'ccc'), (5, 'bbb'), (6, 'aaa');


create table md_int2(id2 int not null, col1 short);
insert into md_int2 values(2, 5), (4, 10), (6, 10), (2, 5), (1, 5), (4, 10);



--TEST: without table aliases + over()
select md_int1.id1, md_int1.col1, md_int2.col1, count(all md_int2.id2) over() cnt from md_int1, md_int2 where md_int1.id1=md_int2.id2 and md_int2.col1 < 10 order by 1, 2, 3;
--TEST: without table aliases + over(partition by ..)
select md_int2.id2, md_int1.col1, md_int2.col1, count(md_int2.id2) over(partition by md_int1.id1) cnt from md_int1, md_int2 where md_int1.id1=md_int2.id2 and md_int2.col1 < 10 order by 1, 2, 3, 4;


--TEST: inner join + over(order by ...)
select m1.id1, m1.col1, m2.col1, count(m1.col1) over(order by m1.col1) cnt from md_int1 as m1 inner join md_int2 as m2 on m1.id1=m2.id2 order by 1, 2, 3;
--TEST: inner join + over(partition by ... order by ...)
select m2.id2, m1.col1, m2.col1, count(distinct m2.col1) over(partition by m1.id1 order by m2.col1) cnt from md_int1 as m1 inner join md_int2 as m2 on m1.id1=m2.id2 order by 1, 2, 3;


--TEST: left outer join + over()
select m2.id2, m1.col1, count(*) over() cnt from md_int1 m1 left outer join md_int2 m2 on m1.id1=m2.id2 where m1.id1 > (select avg(id1) from md_int1) order by 1, 2, 3;
select m2.id2, m1.col1, count(distinct id2) over() cnt from md_int1 m1 left outer join md_int2 m2 on m1.id1=m2.id2 where m1.id1 > (select avg(id1) from md_int1) order by 1, 2, 3;
--TEST: left outer join + over(partition by ...)
select m2.id2, m2.col1, m1.col1, count(m1.col1) over(partition by m1.col1) cnt from md_int1 m1 left outer join md_int2 m2 on m1.id1=m2.id2 where m1.id1 > (select avg(id1) from md_int1) order by 1, 2, 3;


--TEST: right outer join + over(order by ...)
select m1.id1, m2.col1, m1.col1, count(distinct m2.id2) over(order by m1.col1, m2.col1) cnt from md_int1 m1 right outer join md_int2 m2 on m1.id1=m2.id2 where m1.id1 < (select avg(id2) from md_int2) order by 1, 2, 3;
--TEST: right outer join + over(partition by ... order by ...)
select m1.id1, m2.col1, m1.col1, count(all m2.col1) over(partition by m2.col1 order by m1.id1, m1.col1) cnt from md_int1 m1 right outer join md_int2 m2 on m1.id1=m2.id2 order by m1.id1 order by 1, 2, 3;
select *, count(m1.col1) over(partition by m2.id2) from md_int2 m2 right outer join md_int1 m1 on m1.id1=m2.id2 order by 1, 2, 3, 4, 5;



drop table md_int1, md_int2;






