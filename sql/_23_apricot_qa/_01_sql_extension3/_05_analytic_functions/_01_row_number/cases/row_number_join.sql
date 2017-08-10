--combination with join statements



create table rn_join1(id1 int not null, col1 char(20));
insert into rn_join1 values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into rn_join1 values(1, 'fff'), (2, 'eee'), (3, 'ddd'), (4, 'ccc'), (5, 'bbb'), (6, 'aaa');


create table rn_join2(id2 int not null, col1 short);
insert into rn_join2 values(2, 5), (4, 10), (6, 10), (2, 5), (1, 5), (4, 10);



--TEST: without table aliases + over()
select row_num from (select rn_join1.id1, rn_join2.col1, row_number() over() row_num from rn_join1, rn_join2 where rn_join1.id1=rn_join2.id2 and rn_join2.col1 < 10) order by 1;
--TEST: without table aliases + over(partition by ..)
select row_num from (select rn_join2.id2, rn_join1.col1, row_number() over(partition by rn_join1.id1) row_num from rn_join1, rn_join2 where rn_join1.id1=rn_join2.id2 and rn_join2.col1 < 10) order by 1;


--TEST: inner join + over(order by ...)
select row_num from (select m1.id1, m1.col1, row_number() over(order by m1.col1) row_num from rn_join1 as m1 inner join rn_join2 as m2 on m1.id1=m2.id2) order by 1;
--TEST: inner join + over(partition by ... order by ...)
select m2.id2, m1.col1, m2.col1, row_number() over(partition by m1.col1 order by m2.col1) row_num from rn_join1 as m1 inner join rn_join2 as m2 on m1.id1=m2.id2 order by 1, 2, 3, 4;


--TEST: left outer join + over()
select row_num from (select m1.id1, m2.id2, m1.col1, row_number() over() row_num from rn_join1 m1 left outer join rn_join2 m2 on m1.id1=m2.id2 where m1.id1 > (select avg(id1) from rn_join1)) order by 1;
--TEST: left outer join + over(partition by ...)
select row_num from (select m1.id1, m2.col1, row_number() over(partition by m1.col1) row_num from rn_join1 m1 left outer join rn_join2 m2 on m1.id1=m2.id2 where m1.id1 > (select avg(id1) from rn_join1)) order by 1;


--TEST: right outer join + over(order by ...)
select m1.id1, m2.col1, m1.col1, row_number() over(order by m1.col1, m2.col1) row_num from rn_join1 m1 right outer join rn_join2 m2 on m1.id1=m2.id2 where m1.id1 < (select avg(id2) from rn_join2, 1, 3, 4;
--TEST: right outer join + over(partition by ... order by ...)
select m1.id1, m2.col1, m1.col1, row_number() over(partition by m2.col1 order by m1.id1, m1.col1) row_num from rn_join1 m1 right outer join rn_join2 m2 on m1.id1=m2.id2 order by m1.id1, 1, 3, 4;



drop table rn_join1, rn_join2;






