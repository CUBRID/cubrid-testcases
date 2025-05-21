--TEST: [Multi-table Update] ERROR: Semantic: System error (generate var) in /home1/build/workspace/trunk/src/parser/xasl_generation.c (line: 8941) error occurs when preparing a multi-table update statement with right outer join.


create table t1(id1 bigint, col1 time);
insert into t1 values(1000000, '12:12:12'), (2000000, '12:12:13');

create table t2(id2 bigint, col2 time);
insert into t2 values(1, '11:11:11'), (2, '12:12:12');

update t1 m1 right outer join t2 m2 on m1.col1=m2.col2 set m1.col1=date_add(m2.col2, interval 2 second);
prepare st from 'update t1 m1 right outer join t2 m2 on m1.col1=m2.col2 set m1.col1=date_add(m2.col2, interval ? second);';

deallocate prepare st;

drop table t1, t2;

