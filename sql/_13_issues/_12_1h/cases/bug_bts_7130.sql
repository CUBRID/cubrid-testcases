--TEST: [Multi-table Update] Data is in the wrong partition after updating 2 range partition tables with right outer join.


create table p1(col1 time)
partition by range(col1) (
	partition p1 values less than (time'12:12:13'),
	partition p2 values less than (time'12:12:15'),
	partition p3 values less than (time'12:12:18')
);

insert into p1 values('12:12:16'), ('12:12:17'), ('12:12:15');


create table p2(col2 time)
partition by range(col2) (
	partition p1 values less than (time'12:12:12'),
	partition p2 values less than (time'12:12:16'),
	partition p3 values less than (time'14:14:15')
);

insert into p2 values('12:12:16'), ('12:12:16'), ('12:12:17');

select * from p1 right outer join p2 on p1.col1=p2.col2 order by 1, 2;

update p1 right outer join p2 on p1.col1=p2.col2 set p1.col1=p2.col2-2, p2.col2=p1.col1;

select * from p1__p__p1 order by 1;

select * from p1__p__p2 order by 1;

select * from p1__p__p3 order by 1;

select * from p1 order by 1;

select * from p1 where col1>time'12:12:13' order by 1;
select * from p1 where col1<time'12:12:15' order by 1;

drop table p1;
drop table p2;
