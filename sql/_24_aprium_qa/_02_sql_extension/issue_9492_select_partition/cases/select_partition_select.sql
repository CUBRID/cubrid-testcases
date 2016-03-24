--test with select syntax


create table t1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP, col2 char(50))
partition by list(col2) (
partition p1 values in ('cubrid', 'mysql', 'abc'),
partition p2 values in ('cubridcubrid', 'mysqlmysql', 'abcabc'),
partition p3 values in ('updated', 'inserted')
);
insert into t1 values(11111.11111, '2011-09-01 12:12:12', 'cubrid'), (22222.22222, '2011-09-01 12:12:13', 'mysql'), (33333.33333, '2011-09-01 12:12:14', 'abc'), (44444.44444, '2011-09-01 12:12:15', 'cubridcubrid'), (55555.55555, '2011-09-01 12:12:16', 'mysqlmysql'), (66666.66666, '2011-09-01 12:12:17', 'abcabc');


create table t2(col1 varchar(1024), id2 numeric(10, 5), index i(id2 desc, col1))
partition by list(col1) (
partition p1 values in ('cubrid', 'mysql', 'abc'),
partition p2 values in ('cubridcubrid', 'mysqlmysql', 'abcabc', 'abcabcabc'),
partition p3 values in ('a', 'aa', 'aaa', 'aaaa'),
partition p4 values in ('hello', 'hellohello'),
partition p5 values in ('updated', 'inserted')
);
insert into t2 values('cubrid', 1234.12345), ('abcabc', 3456.34555), ('a', 55555.55555), ('abcabc', 444.12345), ('aa', 5555.1234), ('mysql', 22222.22222);
insert into t2 values('cubridcubrid', 666.6666), ('mysqlmysql', 44444.44444), ('aaaa', 5656.56565), ('abcabcabc', 66666.66666), ('hello', 77.88777), ('hellohello', 90000.909);


--TEST: select from the partition
select * from t1 partition (p1) order by id1;
select * from t1 partition (p2) order by id1;
select * from t1 partition (p3) order by id1;
select * from t2 partition (p1) order by id2;
select * from t2 partition (p2) order by id2;
select * from t2 partition (p3) order by id2;
select * from t2 partition (p4) order by id2;
select * from t2 partition (p5) order by id2;


--TEST: with where clause
select * from t1 partition (p1) t1, t2 partition (p1) t2 where t1.col2=t2.col1 and t1.id1 > 11111.11111 order by 1, 2;
select * from t1 partition (p2) t1, t2 partition (p2) t2 where t1.col2=t2.col1 and t2.col1=any(select t2.col1 from t1 partition (p1), t2 partition (p2)) order by 1, t2.id2;
select * from t1 partition (p1) t1 right outer join t2 partition (p3) t2 on t1.id1=t2.id2 where t1.col2 in (select col1 from t2 partition (p1)) order by 1, 2;


--TEST: with group by
select * from t2 partition (p3), t2 partition (p1) where (t2 partition (p3)).col2=(t2 partition (p1)).col1 group by (t2 partition (p3)).col1 order by 1, 2;
select * from t1 partition (p1) a left outer join t2 partition (p1) b on a.col2=b.col1 group by b.col1 order by 1, 2;


--TEST: limit
select * from t1 partition (p2) a right outer join t2 partition (p2) b on a.id1=b.id2 left outer join t1 partition (p1) c on b.col1=c.col2 order by a.id1, b.col1, c.id1,b.id2 limit 2;


drop table t1, t2;





