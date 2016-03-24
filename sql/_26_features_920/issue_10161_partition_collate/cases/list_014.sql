set names utf8;

CREATE TABLE t1 (a VARCHAR(10) default 'A', b int) collate utf8_en_cs
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('a'),
    PARTITION a2 VALUES IN ('A')
);

insert into t1 partition(a1) values (default, 1);
insert into t1 partition(a2) values (default, 2);

alter table t1 remove partitioning;
insert into t1 select * from t1;

select * from t1 order by 1,2;

drop table t1;

set names iso88591;
