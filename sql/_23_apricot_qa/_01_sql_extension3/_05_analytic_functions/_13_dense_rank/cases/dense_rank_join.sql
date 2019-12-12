--combination with join statements



create table drank_join1(id1 int not null, col1 char(20));
insert into drank_join1 values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into drank_join1 values(1, 'fff'), (2, 'eee'), (3, 'ddd'), (4, 'ccc'), (5, 'bbb'), (6, 'aaa');


create table drank_join2(id2 int not null, col1 short);
insert into drank_join2 values(2, 5), (4, 10), (6, 10), (2, 5), (1, 5), (4, 10);



--TEST: without table aliases + over()
select drank_join1.id1, drank_join1.col1, drank_join2.col1, dense_rank() over() d_rank from drank_join1, drank_join2 where drank_join1.id1=drank_join2.id2 and drank_join2.col1 < 10 order by 1, 2, 3;
--TEST: without table aliases + over(partition by ..)
select drank_join2.id2, drank_join1.col1, drank_join2.col1, dense_rank() over(partition by drank_join1.id1) d_rank from drank_join1, drank_join2 where drank_join1.id1=drank_join2.id2 and drank_join2.col1 < 10 order by 1, 2, 3;


--TEST: inner join + over(order by ...)
select m1.id1, m1.col1, m2.col1, dense_rank() over(order by m1.col1) d_rank from drank_join1 as m1 inner join drank_join2 as m2 on m1.id1=m2.id2 order by 1, 2, 3;
--TEST: inner join + over(partition by ... order by ...)
select m2.id2, m1.col1, m2.col1, dense_rank() over(partition by m1.col1 order by m2.col1) d_rank from drank_join1 as m1 inner join drank_join2 as m2 on m1.id1=m2.id2 order by 1, 2, 3;


--TEST: left outer join + over()
select m2.id2, m1.col1, dense_rank() over() d_rank from drank_join1 m1 left outer join drank_join2 m2 on m1.id1=m2.id2 where m1.id1 > (select avg(id1) from drank_join1) order by 1, 2, 3;
--TEST: left outer join + over(partition by ...)
select m2.id2, m2.col1, dense_rank() over(partition by m1.col1) d_rank from drank_join1 m1 left outer join drank_join2 m2 on m1.id1=m2.id2 where m1.id1 > (select avg(id1) from drank_join1) order by 1, 2, 3;


--TEST: right outer join + over(order by ...)
select m1.id1, m2.col1, m1.col1, dense_rank() over(order by m1.col1, m2.col1) d_rank from drank_join1 m1 right outer join drank_join2 m2 on m1.id1=m2.id2 where m1.id1 < (select avg(id2) from drank_join2) order by 1, 2, 3;
--TEST: right outer join + over(partition by ... order by ...)
select m1.id1, m2.col1, m1.col1, dense_rank() over(partition by m2.col1 order by m1.id1, m1.col1) d_rank from drank_join1 m1 right outer join drank_join2 m2 on m1.id1=m2.id2 order by m1.id1 order by 1, 2, 3;



drop table drank_join1, drank_join2;






