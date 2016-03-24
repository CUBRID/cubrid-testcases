set names utf8;
CREATE TABLE t1 (a VARCHAR(10), b int) collate utf8_en_ci
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('a'),
    PARTITION a2 VALUES IN ('b')
);
insert into t1 select if(rownum%2=0, 'a', 'b'), rownum from db_class x1, db_class x2, db_class x3 limit 20000;

ALTER TABLE t1
REORGANIZE PARTITION a1 INTO (
    PARTITION a1_1 VALUES IN ('a'),
    PARTITION a1_2 VALUES IN ('A')
);
drop table t1;


CREATE TABLE t1 (a VARCHAR(10), b int) collate utf8_en_cs
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('a', 'A'),
    PARTITION a2 VALUES IN ('b')
);
insert into t1 select if(rownum%2=0, 'a', 'A'), rownum from db_class x1, db_class x2, db_class x3 limit 20000;

ALTER TABLE t1
REORGANIZE PARTITION a1 INTO (
    PARTITION a1_1 VALUES IN ('a'),
    PARTITION a1_2 VALUES IN ('A')
);
select count(*) from t1 partition(a1_1);
select count(*) from t1 partition(a1_2);
select count(*) from t1 partition(a2);

drop table t1;


set names iso88591;
