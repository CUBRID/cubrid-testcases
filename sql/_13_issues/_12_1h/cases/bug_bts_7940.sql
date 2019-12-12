create table t(i int primary key);
insert into t select rownum from db_class limit 40;
create table pt(i int) partition by range(i) (partition p0 values less than (10),partition p1 values less than (100));
alter table pt add constraint foreign key ft(i) references t(i);
insert into pt select rownum from db_class limit 40;

alter table pt promote partition p0;
delete from t where i=20;
delete from t where i=4;

drop pt__p__p0;
drop t;
drop pt,t;

--+ holdcas on;
create table t(i int primary key);
insert into t select rownum-2 from db_class limit 7 offset 1;
create table pt(i int,d date) partition by list(weekday(d)) (
partition p0 values in (0,2,4),
partition p1 values in (1,3,5),
partition p2 values in (6));

alter table pt add constraint foreign key ft(i) references t(i);
create trigger tr
after insert on pt
execute update pt set i=weekday(obj.d);
insert into pt(d) values ('2013-12-24');
alter trigger tr status inactive;
alter table pt promote partition p2;
delete from t where i= 1;
drop pt;
drop pt__p__p2;
drop t;
commit;

--+ holdcas off;



