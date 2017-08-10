drop table if exists t;

create table t(i int, j int, k int, s varchar(30));

create index i_t_ai on t (abs(i));

create index i_t_j on t(j) where j > 3;

create index i_t_i on t (i);

create index i_t_ji on t (i, j);

create index i_t_s on t (s(10));

show indexes from t;

create index idx1 on t (abs(i));

create index idx2 on t(j) where j > 3;

create index idx3 on t(i);

create index idx4 on t(i, j);

create index idx5 on t(s(10));

show indexes from t;

drop index i_t_ai on t (abs(i));

drop index i_t_i on t (i);

drop index idx1 on t(abs(i));

drop index i_t_j on t;

drop index i_t_ji on t;

drop index i_t_s on t;

drop index idx3 on t;

show indexes from t;

drop table t;
