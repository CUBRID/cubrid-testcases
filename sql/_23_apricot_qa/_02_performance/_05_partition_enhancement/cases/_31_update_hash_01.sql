set system parameters 'dont_reuse_heap_file=yes';
drop if exists temp;
drop if exists t;

create table t(d date) partition by hash(d) partitions 25;
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

select d,count(*) from t__p__p0 where d <> '2012-5-6' group by d;
select d,count(*) from t__p__p2 where d <> '2012-5-6' group by d;
select d,count(*) from t__p__p17 where d <> '2012-5-6' group by d;
select d,count(*) from t__p__p24 where d <> '2012-5-6' group by d;
select count(*) from t__p__p21 where d='2015-03-6';
select count(*) from t where d='2012-5-6';

update /*+ recompile */ t set d=add_months(d,5) where d in ('2014-10-06');
update /*+ recompile */ t set d=add_months(d,5) where d in ('2012-5-6'); 

select count(*) from t where d='2014-10-6';
select count(*) from t where d='2015-03-6';
select count(*) from t__p__p21 where d='2015-03-6';
select count(*) from t where d='2012-5-6';
select count(*) from t where d=add_months('2012-5-6',5);

alter table t promote partition p21;
alter table t add partition partitions 10;

select * from db_partition where class_name='t' order by 3;
select d,count(*) from t__p__p0 where d <> '2012-5-6' group by d;
select d,count(*) from t__p__p2 where d <> '2012-5-6' group by d;
select d,count(*) from t__p__p17 where d <> '2012-5-6' group by d;
select d,count(*) from t__p__p24 where d <> '2012-5-6' group by d;
select d,count(*) from t__p__p25 where d <> '2012-5-6' group by d;
select d,count(*) from t__p__p34 where d <> '2012-5-6' group by d;
select count(*) from t where d='2012-5-6' group by d;

drop t;
drop temp;
set system parameters 'dont_reuse_heap_file=no';
