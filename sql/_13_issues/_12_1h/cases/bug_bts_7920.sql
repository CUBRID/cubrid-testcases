create table t(t timestamp,v varchar(100)) partition by list(t) (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'),
partition p3 values in ('1973-10-11'));
insert into t(t) values('1970-3-10'),('1971-2-01'),('1972-2-19'),('1973-10-11');

alter table t promote partition p1;
create reverse index ri on t__p__p1(last_day(t));

alter table t__p__p1 partition by list(t)  (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'),
partition p3 values in ('1973-10-11'));

insert into t__p__p1 values('1970-3-11','');
insert into t__p__p1 values('1970-3-10','');
drop t,t__p__p1;

create table t(t timestamp,v varchar(100)) partition by range(t) (
partition p0 values less than ('1970-3-10'),
partition p1 values less than ('1971-2-01'),
partition p2 values less than ('1972-2-19'),
partition p3 values less than ('1973-10-11'),
partition p4 values less than maxvalue);
insert into t(t) values('1970-3-10'),('1971-2-01'),('1972-2-19'),('1973-10-11');

alter table t promote partition p1;
create unique index u_t__p__p1_i on t__p__p1(t);
alter table t__p__p1 partition by list(t)  (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'),
partition p3 values in ('1973-10-11'));

alter table t__p__p1 promote partition p2;
create index i on t__p__p1__p__p2(t) where t >'1972-3-6';
replace into t__p__p1__p__p2 values('1973-10-11','NULL');

drop t__p__p1__p__p2, t__p__p1,t;



