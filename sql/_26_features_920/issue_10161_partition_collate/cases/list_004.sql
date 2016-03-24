
set names utf8;
CREATE TABLE t1 (name VARCHAR (40), event VARCHAR (30) collate utf8_en_ci, primary key(name,event))
PARTITION BY LIST (event) (
    PARTITION event1 VALUES IN ('A')

);

ALTER TABLE t1 ADD PARTITION (
    PARTITION event2 VALUES IN ('a')
);

ALTER TABLE t1 ADD PARTITION (
    PARTITION event3 VALUES IN ('B')
);

ALTER TABLE t1 ADD PARTITION (
    PARTITION event4 VALUES IN ('b')
);

ALTER TABLE t1 ADD PARTITION (
    PARTITION event5 VALUES IN (_utf8'C')
);

ALTER TABLE t1 ADD PARTITION (
    PARTITION event6 VALUES IN (_iso88591'D')
);

ALTER TABLE t1 ADD PARTITION (
    PARTITION event7 VALUES IN (_euckr'E')
);

ALTER TABLE t1 ADD PARTITION (
    PARTITION event8 VALUES IN ('e')
);

ALTER TABLE t1 ADD PARTITION (
    PARTITION event9 VALUES IN (_iso88591'F'),
    PARTITION event10 VALUES IN (_euckr'F')
);

insert into t1 select '1', 'A';
insert into t1 select '2', 'a';
insert into t1 select '3', 'B';
insert into t1 select '4', 'b';
insert into t1 select '5', 'C';
insert into t1 select '6', 'c';
insert into t1 select '7', 'D';
insert into t1 select '8', 'd';

ALTER TABLE t1 PROMOTE PARTITION event1;
ALTER TABLE t1 PROMOTE PARTITION event3;
ALTER TABLE t1 PROMOTE PARTITION event5;
ALTER TABLE t1 PROMOTE PARTITION event6;
ALTER TABLE t1 PROMOTE PARTITION event7;

select * from t1 order by 1,2;

drop table t1;
drop table t1__p__event1;
drop table t1__p__event3;
drop table t1__p__event5;
drop table t1__p__event6;
drop table t1__p__event7;

set names iso88591;
