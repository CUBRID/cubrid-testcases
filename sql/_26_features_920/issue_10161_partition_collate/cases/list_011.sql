set names utf8;

CREATE TABLE t1 (a VARCHAR(10) default 'A', b int) collate utf8_en_cs
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('a'),
    PARTITION a2 VALUES IN ('A')
);

insert into t1 partition(a1) values ('A', 1);
insert into t1 partition(a1) values ('a', 2);
insert into t1 partition(a2) values ('A', 3);
insert into t1 partition(a2) values ('a', 4);

insert into t1 select a, b+100 from t1;

select * from t1 order by 1,2;

update t1 partition(a1) set a='A' where b=3;
update t1 partition(a1) set a='a' where b=3;
update t1 partition(a2) set a='A' where b=3;
update t1 partition(a2) set a='a' where b=3;

update t1 partition(a2) set a='A' where b=2;
update t1 partition(a2) set a='a' where b=2;
update t1 partition(a1) set a='A' where b=2;
update t1 partition(a1) set a='a' where b=2;

select * from t1 order by 1,2;

delete from t1 partition(a1) where a='A';
delete from t1 partition(a2) where a='a';
select * from t1 order by 1,2;

delete from t1 partition(a1) where a='a';
delete from t1 partition(a2) where a='A';
select * from t1 order by 1,2;

drop table t1;

set names iso88591;