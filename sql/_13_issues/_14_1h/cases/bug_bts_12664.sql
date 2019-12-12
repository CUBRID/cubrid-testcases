drop if exists t;
create table t(i int,j int);
insert into t values(1,3),(2,2),(2,3),(3,3);
select i,j,i+j,row_number() over(partition by i+j) from t;
select i,j,row_number() over(partition by i+j) from t;
drop t;

drop if exists s;
create table s(i int auto_increment,j int);
insert into s(j) values(500),(500),(500),(501),(501),(501),(502),(502);
select i,j,row_number() over(partition by i+j) from s;
select i,j,i+j,row_number() over(partition by i+j) from s;
select j,row_number() over(partition by i+j) from s;
select i,row_number() over(partition by i+j) from s;
select i,row_number() over(partition by i) from s;
select j,row_number() over(partition by j) from s;
select row_number() over(partition by i) from s;
select row_number() over(partition by i+j) from s;
drop s;

drop if exists s;
create table s(i int auto_increment,j varchar(5));
insert into s(j) values('500'),('500'),('500'),('501'),('501'),('501'),('502'),('502');
select i,j,row_number() over(partition by i+j) from s;
select i,j,i+j,row_number() over(partition by i+j) from s;
drop s;

drop if exists t;
create table t(i int,j char(1));
insert into t values(1,'3'),(2,'2'),(2,'3'),(3,'3');
select i,j,i+j,row_number() over(partition by i+j) from t;
select i,j,row_number() over(partition by i+j) from t;
drop t;

create table t(i varchar(10),j varchar(5));
insert into t values('a','3'),('b','2'),('c','3'),('3','3');
select i,j,i+j,row_number() over(partition by i+j) from t;
select i,j,row_number() over(partition by i+j) from t;
insert into t values('a','3');
select i,j,i+j,row_number() over(partition by i+j) from t;
select i,j,row_number() over(partition by i+j) from t;
drop t;

create table t(i varchar(10),j int);
insert into t values('a',3),('b',2),('c',3),('3',3);
select i,j,i+j,row_number() over(partition by i+j) from t;
select i,j,row_number() over(partition by i+j) from t;
drop t;

create table t(col1 varchar(10));
insert into t values('cubrid'),('mysql'),('oracle'),('kingbase'),('informix'),('db2');
insert into t values('cubrid'),('mysql'),('oracle'),('kingbase'),('informix'),('db2');
insert into t values('cubrid'),('mysql'),('oracle'),('kingbase'),('informix'),('db2');
select col1,row_number() over(partition by col1) from t;
select left(col1,3),row_number() over(partition by left(col1,3)) from t;
drop t;

