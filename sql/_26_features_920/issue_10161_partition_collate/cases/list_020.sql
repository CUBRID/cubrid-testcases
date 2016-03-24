SET NAMES utf8 COLLATE utf8_es_cs; 
CREATE TABLE t1 (a VARCHAR(10), b int, index i_a (a)) collate utf8_es_cs
PARTITION BY LIST (lower(a)) (
    PARTITION a1 VALUES IN ('N'),
    PARTITION a2 VALUES IN ('ñ'),
    PARTITION a3 VALUES IN ('Ñ')
);

insert into t1 values ('N', 1);
insert into t1 values ('ñ', 2);
insert into t1 values ('Ñ', 3);

insert into t1 select lower(a),b+10 from t1;

select * from t1 partition(a1) order by b;
select * from t1 partition(a2) order by b;
select * from t1 partition(a3) order by b;
drop table t1;

set names iso88591;