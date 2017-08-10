create table t (i int, index (i));

create table t (i int, index idx(i));

drop table t;

create table t (i int, j int, index (i,j));

create table t (i int, j int, index idx (i,j));

drop table t;

create table t (s varchar(30), index (s(10)));

create table t (s varchar(30), index idx (s(10)));

drop table t;

create table t (i int, index (abs(i));

create table t (i int, index idx (abs (i)));

drop table t;

create table t (i int, key (i));

create table t (i int, key idx(i));

drop table t;

create table t (i int, j int, key (i,j));

create table t (i int, j int, key idx(i,j));

drop table t;

create table t (s varchar(30), key (s(10)));

create table t (s varchar(30), key idx (s(10)));

drop table t;

create table t (i int, key (abs(i));

create table t (i int, key idx (abs (i)));

drop table t;
