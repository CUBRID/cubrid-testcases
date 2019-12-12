--combination with join statements

drop table if exists p_cont_int1, p_cont_int2;

create table p_cont_int1(id1 int not null, col1 char(20));
insert into p_cont_int1 values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into p_cont_int1 values(1, 'fff'), (2, 'eee'), (3, 'ddd'), (4, 'ccc'), (5, 'bbb'), (6, 'aaa');


create table p_cont_int2(id2 int not null, col1 short);
insert into p_cont_int2 values(2, 5), (4, 10), (6, 10), (2, 5), (1, 5), (4, 10);



--TEST: without table aliases + over()
select p_cont_int1.id1, p_cont_int1.col1, p_cont_int2.col1, percentile_cont(0.4) within group (order by p_cont_int2.id2 desc) over() p_cont from p_cont_int1, p_cont_int2 where p_cont_int1.id1=p_cont_int2.id2 and p_cont_int2.col1 < 10 order by 1, 2, 3;
--TEST: without table aliases + over(partition by ..)
select p_cont_int2.id2, p_cont_int1.col1, p_cont_int2.col1, percentile_cont(0.8) within group (order by p_cont_int2.id2) over(partition by p_cont_int1.id1) p_cont from p_cont_int1, p_cont_int2 where p_cont_int1.id1=p_cont_int2.id2 and p_cont_int2.col1 < 10 order by 1, 2, 3;


--TEST: inner join
select m1.id1, m1.col1, m2.col1, percentile_cont(0.3) within group (order by m2.col1 desc) over(partition by m1.col1) p_cont from p_cont_int1 as m1 inner join p_cont_int2 as m2 on m1.id1=m2.id2 order by 1, 2, 3;
--TEST: inner join + over(partition by ... order by ...)
select m2.id2, m1.col1, m2.col1, percentile_cont(0.5) within group (order by m2.col1) over(partition by m1.id1) p_cont from p_cont_int1 as m1 inner join p_cont_int2 as m2 on m1.id1=m2.id2 order by 1, 2, 3;


--TEST: left outer join + over()
select m2.id2, m1.col1, percentile_cont(0.99) within group (order by m1.id1) over() p_cont from p_cont_int1 m1 left outer join p_cont_int2 m2 on m1.id1=m2.id2 where m1.id1 > (select percentile_cont(0.38) within group (order by id1) from p_cont_int1) order by 1, 2, 3;
--TEST: left outer join + over(partition by ...)
select m1.id1, m1.col1, m2.id2, m2.col1, percentile_cont(0.221) within group (order by m1.id1) over(partition by m2.col1) p_cont from p_cont_int1 m1 left outer join p_cont_int2 m2 on m1.id1=m2.id2 where m1.id1 > (select percentile_cont(0.44) within group (order by id2) from p_cont_int2) order by 1, 2, 3;


--TEST: right outer join + over(partition by ...)
select m1.id1, m2.col1, m1.col1, percentile_cont(0.789) within group (order by m2.col1) over(partition by m1.col1) p_cont from p_cont_int1 m1 right outer join p_cont_int2 m2 on m1.id1=m2.id2 order by m1.id1, 2, 3;



drop table p_cont_int1, p_cont_int2;






