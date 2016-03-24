set names utf8;

CREATE TABLE t1 (a VARCHAR(10) default 'A', b varchar(10) ) collate utf8_en_cs
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('a')
);

insert into t1 values ('a', 'a');
insert into t1 values ('A', 'A');
insert into t1 values (default, 'A');
insert into t1 values (default(a), 'A');
insert into t1 values (lower(default(a)), 'A');
update t1 set a=b;
insert into t1 select 'A', 'A' from t1;
insert into t1 select * from t1;
select * from t1 order by 1, 2;


insert into t1 select * from t1;
create view v1 as select * from t1 order by 1,2 limit 3;
update v1 set b='X';
update v1 set a='A';
update v1 set a='a';

select * from t1 order by 1, 2;

drop view v1;
drop table t1;

set names iso88591;

