set system parameters 'dont_reuse_heap_file=yes';
drop table if exists t;
drop table if exists temp;

create table t(d date) partition by hash(add_months(d,3)) partitions 25;
create table temp(i int);
insert into temp select rownum from db_class limit 65;
insert into t select add_months('2014-05-06',i) from temp;
insert into t values('2012-5-6');
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;

select * from db_partition where class_name='t' order by 3;
select * from db_class where class_name='t';

select d,add_months(d,3),count(*) from t__p__p0 where d <> '2012-5-6' group by d;
select d,add_months(d,3),count(*) from t__p__p2 where d <> '2012-5-6' group by d;
select d,add_months(d,3),count(*) from t__p__p17 where d <> '2012-5-6' group by d;
select d,add_months(d,3),count(*) from t__p__p24 where d <> '2012-5-6' group by d;
select count(*) from t__p__p2 where d='2015-08-6';
select count(*) from t where d='2012-5-6';

update /*+ recompile */ t set d=add_months(d,13) where add_months(d,3) in ('2014-10-06');
update /*+ recompile */ t set d=add_months(d,13) where add_months(d,3) in (add_months('2012-5-6',3));
select count(*) from t where add_months(d,3)='2014-10-06';
select count(*) from t where d='2015-08-6';
select count(*) from t__p__p2 where add_months(d,3)='2015-11-06';
select count(*) from t where add_months(d,3)='2012-5-6';
select count(*) from t where d=add_months('2012-5-6',13);

alter table t coalesce partition 4;
select * from db_partition where class_name='t' order by 3;

select d,count(*) from t__p__p0 where d <> '2012-5-6' group by d order by 1;
select d,count(*) from t__p__p2 where d <> '2012-5-6' group by d order by 1;
select d,count(*) from t__p__p17 where d <> '2012-5-6' group by d order by 1;
select d,count(*) from t__p__p18 where d <> '2012-5-6' group by d order by 1;

drop t;
drop temp;

set system parameters 'dont_reuse_heap_file=no';
