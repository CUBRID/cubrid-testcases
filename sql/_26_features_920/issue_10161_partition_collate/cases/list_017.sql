SET NAMES utf8 COLLATE utf8_de_exp_ai_ci; 
CREATE TABLE t1 (a VARCHAR(10), b int) collate utf8_de_exp_ai_ci
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('AE'),
    PARTITION a2 VALUES IN ('OE'),
    PARTITION a3 VALUES IN ('UE')
);

insert into t1 values ('ä', 1);
insert into t1 values ('AE', 2);
insert into t1 values ('Ä', 3);

insert into t1 values ('OE', 4);
insert into t1 values ('ö', 5);
insert into t1 values ('Ö', 6);

insert into t1 values ('UE', 7);
insert into t1 values ('ü', 8);
insert into t1 values ('Ü', 9);

select * from t1 order by 1, 2;
select a, hex(a) from (select distinct a from t1) order by 2;
drop table t1;


SET NAMES utf8 COLLATE utf8_de_exp_ai_ci; 
CREATE TABLE t1 (a VARCHAR(10), b int) collate utf8_de_exp_ai_ci
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('Ä'),
    PARTITION a2 VALUES IN ('Ö'),
    PARTITION a3 VALUES IN ('Ü')
);

insert into t1 values ('ä', 1);
insert into t1 values ('AE', 2);
insert into t1 values ('Ä', 3);

insert into t1 values ('OE', 4);
insert into t1 values ('ö', 5);
insert into t1 values ('Ö', 6);

insert into t1 values ('UE', 7);
insert into t1 values ('ü', 8);
insert into t1 values ('Ü', 9);

select * from t1 order by 1, 2;
select a, hex(a) from (select distinct a from t1) order by 2;

drop table t1;

set names iso88591;
