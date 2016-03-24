create table t(i int auto_increment unique) partition by list(i) (partition p0 values in (1),partition p1 values in (2));
insert into t values(1),(2);
alter table t promote partition p0;
describe t;
describe t__p__p0;
show indexes from t;
show indexes from t__p__p0;
insert into t select NULL from db_class;
insert into t__p__p0 select NULL from db_class limit 1;
drop t,t__p__p0;

create table t0(i int primary key);
create table t(i int auto_increment unique) partition by range(mod(i,6)) (
partition p0 values less than (4),
partition p1 values less than (7));
insert into t0 select rownum from db_class limit 10;
insert into t select rownum from db_class limit 9;
alter table t add constraint foreign key fk(i) references t0(i);
alter table t promote partition p0;
describe t;
describe t__p__p0;
show indexes from t;
show indexes from t__p__p0;
insert into t select NULL from db_class limit 3;
insert into t__p__p0 select NULL from db_class limit 1;
select * from t order by 1;
select * from t__p__p0 order by 1 desc;
drop t,t0,t__p__p0;

create table t(i int) partition by list(i) (partition p0 values in (1),partition p1 values in (2));
insert into t values(1),(2);
create reverse index i on t(i);
alter table t promote partition p0;
describe t;
describe t__p__p0;
show indexes from t;
show indexes from t__p__p0;
insert into t select NULL from db_class;
insert into t__p__p0 select NULL from db_class limit 1;
drop t,t__p__p0;
