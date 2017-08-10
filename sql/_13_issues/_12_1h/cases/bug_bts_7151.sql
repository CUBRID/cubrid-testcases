--TEST:  [Multi-table Update] 'Appropriate partition does not exist' error occurs when updating 2 partition tables though there is appropriate partition.


create table p1(id1 int)
partition by list(id1) (
	partition p1 values in (1, 3, 5, 7, 9),
	partition p2 values in (2, 4, 6, 8, 10)
);

insert into p1 values(1), (3), (4), (8);

create table p2(id2 int) partition by hash(id2) partitions 3;

insert into p2 values(1), (2), (5), (6), (8);

select * from p1 order by 1;

select * from p2 order by 1;

update p1, p2 set p1.id1=p2.id2+1, p2.id2=p1.id1+1 where p1.id1=p2.id2;
select * from p1 order by 1;
select * from p2 order by 1;
select * from p1 where id1 < 8 order by 1;
select * from p2 where id2 > 3 order by 1;

update p1, p2 set p1.id1=3, p2.id2=8 where p1.id1=p2.id2;

select * from p1 order by 1;
select * from p2 order by 1;
select * from p1 where id1 >=3 order by 1;
select * from p2 where id2 <=8 order by 1;

drop table p1;
drop table p2;



