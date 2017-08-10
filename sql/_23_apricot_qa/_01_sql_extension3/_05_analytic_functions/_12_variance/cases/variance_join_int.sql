--combination with join statements



create table variance_int1(id1 int not null, col1 char(20));
insert into variance_int1 values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into variance_int1 values(1, 'fff'), (2, 'eee'), (3, 'ddd'), (4, 'ccc'), (5, 'bbb'), (6, 'aaa');


create table variance_int2(id2 int not null, col1 short);
insert into variance_int2 values(2, 5), (4, 10), (6, 10), (2, 5), (1, 5), (4, 10);



--TEST: without table aliases + over()
select variance_int1.id1, variance_int1.col1, variance_int2.col1, variance(all variance_int2.id2) over() variance from variance_int1, variance_int2 where variance_int1.id1=variance_int2.id2 and variance_int2.col1 < 10 order by 1, 2, 3;
--TEST: without table aliases + over(partition by ..)
select variance_int2.id2, variance_int1.col1, variance_int2.col1, variance(variance_int2.id2) over(partition by variance_int1.id1) variance from variance_int1, variance_int2 where variance_int1.id1=variance_int2.id2 and variance_int2.col1 < 10 order by 1, 2, 3;


--TEST: inner join + over(order by ...)
select m1.id1, m1.col1, m2.col1, variance(m2.col1) over(order by m1.col1) variance from variance_int1 as m1 inner join variance_int2 as m2 on m1.id1=m2.id2 order by 1, 2, 3;
--TEST: inner join + over(partition by ... order by ...)
select m2.id2, m1.col1, m2.col1, variance(distinct m2.col1) over(partition by m1.id1 order by m2.col1) variance from variance_int1 as m1 inner join variance_int2 as m2 on m1.id1=m2.id2 order by 1, 2, 3;


--TEST: left outer join + over()
select m2.id2, m1.col1, variance(unique m1.id1) over() variance from variance_int1 m1 left outer join variance_int2 m2 on m1.id1=m2.id2 where m1.id1 > (select variance(id1) from variance_int1) order by 1, 2, 3;
--TEST: left outer join + over(partition by ...)
select m2.id2, m2.col1, variance(all m2.col1) over(partition by m1.col1) variance from variance_int1 m1 left outer join variance_int2 m2 on m1.id1=m2.id2 where m1.id1 > (select variance(id1) from variance_int1) order by 1, 2, 3;


--TEST: right outer join + over(order by ...)
select m1.id1, m2.col1, m1.col1, variance(distinct m2.id2) over(order by m1.col1, m2.col1) variance from variance_int1 m1 right outer join variance_int2 m2 on m1.id1=m2.id2 where m1.id1 < (select variance(id2) from variance_int2) order by 1, 2, 3;
--TEST: right outer join + over(partition by ... order by ...)
select m1.id1, m2.col1, m1.col1, variance(all m2.col1) over(partition by m2.col1 order by m1.id1, m1.col1) variance from variance_int1 m1 right outer join variance_int2 m2 on m1.id1=m2.id2 order by m1.id1 order by 1, 2, 3;



drop table variance_int1, variance_int2;






