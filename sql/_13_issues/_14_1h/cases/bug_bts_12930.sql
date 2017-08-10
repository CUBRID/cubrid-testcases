drop table if exists a;
create table a (i int auto_increment primary key);
insert into a values(NULL);
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
delete from a where i>400;
drop table if exists t;
create table t(i int ,j int, unique(i,j));
insert into t select i,i from a;
update statistics on t with fullscan;
show indexes from t;
alter table t partition by range ( i )
(
partition p400 values less than (400),
partition p4000 values less than MAXVALUE
);
show indexes from t;
update statistics on all classes with fullscan;
show indexes from t;
drop t;
create table t(i int,j int, primary key(i,j));
insert into t select i,i from a;
update statistics on t with fullscan;
show indexes from t;
alter table t partition by range ( i )
(
partition p400 values less than (400),
partition p4000 values less than MAXVALUE
);
show indexes from t;
update statistics on all classes with fullscan;
show indexes from t;
drop t;

create table t(i int,j int auto_increment, primary key(i,j));
insert into t select i,i from a;
update statistics on t with fullscan;
show indexes from t;
alter table t partition by range ( i )
(
partition p200 values less than (200),
partition p400 values less than MAXVALUE
);
show indexes from t;
update statistics on all classes with fullscan;
show indexes from t;
drop t;
create table t(i int,j int auto_increment, unique(i,j));
insert into t select i,i from a;
update statistics on t with fullscan;
show indexes from t;
alter table t partition by range ( i )
(
partition p200 values less than (200),
partition p400 values less than MAXVALUE
);
show indexes from t;
update statistics on all classes with fullscan;
show indexes from t;
drop t,a;
