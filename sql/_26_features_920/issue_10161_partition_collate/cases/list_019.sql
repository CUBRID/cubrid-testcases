SET NAMES utf8 COLLATE utf8_ko_cs_uca; 
CREATE TABLE t1 (a VARCHAR(10), b int, index i_a (a)) collate utf8_ko_cs_uca
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('伽佳假'),
    PARTITION a2 VALUES IN ('伽佳'),
    PARTITION a3 VALUES IN ('伽')
);



insert into t1 values ('伽伽伽', 1);
insert into t1 values ('伽伽佳', 2);
insert into t1 values ('伽伽假', 3);
insert into t1 values ('佳伽伽', 4);
insert into t1 values ('假伽伽', 5);
insert into t1 values ('伽佳伽', 6);
insert into t1 values ('伽假伽', 7);

insert into t1 values ('佳假伽', 8);
insert into t1 values ('佳伽假', 9);
insert into t1 values ('伽佳假', 10);

insert into t1 values ('伽伽', 11);
insert into t1 values ('佳伽', 12);
insert into t1 values ('假伽', 13);
insert into t1 values ('伽佳', 14);
insert into t1 values ('伽假', 15);

insert into t1 values ('伽', 16);


insert into t1 values ('OE', 100);
insert into t1 values ('ö', 101);
insert into t1 values ('Ö', 102);

insert into t1 values ('UE', 103);
insert into t1 values ('ü', 104);
insert into t1 values ('Ü', 105);

select * from t1 partition(a1);
select * from t1 partition(a2);
select * from t1 partition(a3);

drop table t1;
set names iso88591;
