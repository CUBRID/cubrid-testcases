drop if exists t;
drop if exists pt;

create table t(i int primary key);
insert into t select rownum from db_class limit 40;
create table pt(i int) partition by range(i) (partition p0 values less than (10),partition p1 values less than (100));
alter table pt add constraint foreign key pt(i) references t(i);
insert into pt select rownum from db_class limit 40;

select * from pt__p__p0 order by 1;
select * from pt__p__p1 order by 1;

alter table pt promote partition p0;
alter table pt__p__p0 add constraint foreign key pt__p__p0(i) references t(i) on delete cascade;

delete from t where i=20;
delete from t where i=2;
select * from pt__p__p0 order by 1;
select * from t order by 1;

drop pt;
drop pt__p__p0;
drop t;

