SET NAMES utf8 COLLATE utf8_de_exp_ai_ci; 
CREATE TABLE t1 (a NCHAR(10), b int) collate utf8_de_exp_ai_ci
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN (N'AE'),
    PARTITION a2 VALUES IN (N'OE'),
    PARTITION a3 VALUES IN (N'UE')
);

insert into t1 values (N'ä', 1);
insert into t1 values (N'AE', 2);
insert into t1 values (N'Ä', 3);

insert into t1 values (N'OE', 4);
insert into t1 values (N'ö', 5);
insert into t1 values (N'Ö', 6);

insert into t1 values (N'UE', 7);
insert into t1 values (N'ü', 8);
insert into t1 values (N'Ü', 9);

select * from t1 order by 1, 2;
select distinct a from t1 order by 1;
drop table t1;


SET NAMES utf8 COLLATE utf8_de_exp_ai_ci; 
CREATE TABLE t1 (a NCHAR(10), b int) collate utf8_de_exp_ai_ci
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN (N'Ä'),
    PARTITION a2 VALUES IN (N'Ö'),
    PARTITION a3 VALUES IN (N'Ü')
);

insert into t1 values (N'ä', 1);
insert into t1 values (N'AE', 2);
insert into t1 values (N'Ä', 3);

insert into t1 values (N'OE', 4);
insert into t1 values (N'ö', 5);
insert into t1 values (N'Ö', 6);

insert into t1 values (N'UE', 7);
insert into t1 values (N'ü', 8);
insert into t1 values (N'Ü', 9);

select * from t1 order by 1, 2;
select distinct a from t1 order by 1;

drop table t1;

set names iso88591;
