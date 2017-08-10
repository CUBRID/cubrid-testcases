create serial s start with 5 increment by 2 cache 5;
create table t(i int) partition by hash(i) partitions 3;
insert into t(i) values (s.next_value), (s.next_value), (s.next_value), (s.next_value), (s.next_value), (s.next_value), (s.next_value), (s.next_value);
select * from t__p__p0 order by i;
select * from t__p__p1 order by i;
select * from t__p__p2 order by i;

alter table t add partition partitions 2;

select * from t__p__p0 order by i;
select * from t__p__p1 order by i;
select * from t__p__p2 order by i;
select * from t__p__p3 order by i;
select * from t__p__p4 order by i;
insert into t(i) values (s.next_value);
select * from t__p__p0 order by 1;

drop t;
drop serial s;









 