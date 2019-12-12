create table t(i int, j int, k int, s varchar(30));

alter table t add index (abs(i));

alter table t add index (j) where j > 3;

alter table t add index (i);

alter table t add index (i, j);

alter table t add index (s(10));

show indexes from t;

alter table t add index idx1 (abs(i));

alter table t add index idx2 (j) where j > 3;

alter table t add index idx3 (i);

alter table t add index idx4 (i, j);

alter table t add index idx5 (s(10));

show indexes from t;

drop table t;