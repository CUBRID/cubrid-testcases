drop table if exists t;
CREATE TABLE t (i int ,j string default user() ,primary key (i));
insert into t values(1,default); 
insert into t(i) values(2);
select i,left(j,3) from t order by 1;

drop table if exists t;
CREATE TABLE t (i int ,j string default user() ,primary key (i));
insert into t (i) select rownum from db_class limit 10 ;
select i,left(j,3) from t order by 1;

drop table if exists t;
CREATE TABLE t (i int ,j string default user() );
insert into t (i) select rownum from db_class limit 10 ;
select i,left(j,3) from t order by 1;

drop table if exists t;
CREATE TABLE t (i int ,j string default user() ) partition by hash(j) partitions 2;
insert into t (i) select rownum from db_class limit 10 ;
select i,left(j,3) from t order by 1;


drop table if exists t;
CREATE TABLE t (i int ,j varchar(100) default user() ) partition by hash(j) partitions 2;
insert into t (i) select rownum from db_class limit 10 ;
select i,left(j,3) from t order by 1;


drop table if exists t;
CREATE TABLE t (i int ,j char(100) default user(),k string default user() ) partition by hash(j) partitions 2;
insert into t (i) select rownum from db_class limit 10 ;
select i,left(j,3),left(k,3) from t order by 1;
drop table t;
