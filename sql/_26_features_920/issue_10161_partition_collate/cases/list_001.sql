
set names utf8;
CREATE TABLE t1 (name VARCHAR (40), event VARCHAR (30) collate utf8_en_cs)
PARTITION BY LIST (event) (
    PARTITION event1 VALUES IN ('A', 'AA'),
    PARTITION event2 VALUES IN ('a', 'aa')
);

insert into t1 values ('a', 'a');
insert into t1 values ('A', 'A');
insert into t1 values ('aa', 'aa');
insert into t1 values ('AA', 'AA');

insert into t1 partition (event2) values ('a', 'a');
insert into t1 partition (event2) values ('aa', 'aa');
insert into t1 partition (event1) values ('AA', 'AA');
insert into t1 partition (event1) values ('A', 'A');

select * from t1 partition (event1) order by 1,2;
select * from t1 partition (event2) order by 1,2;
select * from t1__p__event1 order by 1,2;
select * from t1__p__event2 order by 1,2;

select * from t1 partition(event1) x1, t1__p__event1 x2 where x1.event=x2.event order by 1,2,3,4 ;
select distinct * from t1 partition(event1) x1, t1__p__event1 x2 where x1.event=x2.event order by 1,2,3,4 ;

drop table t1;
set names iso88591;