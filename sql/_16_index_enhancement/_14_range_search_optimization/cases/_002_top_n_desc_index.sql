--+ holdcas on;
-- covering index - ascending index
create table t1 (i1 int, i2 int, i3 int);

insert into t1 value (1,2,1);
insert into t1 value (1,2,2);
insert into t1 value (1,2,3);
insert into t1 value (1,2,4);
insert into t1 value (1,2,4);
insert into t1 value (1,2,5);
insert into t1 value (1,2,6);


insert into t1 value (1,3,1);
insert into t1 value (1,3,2);
insert into t1 value (1,3,3);
insert into t1 value (1,3,4);
insert into t1 value (1,3,5);
insert into t1 value (1,3,5);
insert into t1 value (1,3,6);	


insert into t1 value (1,4,1);
insert into t1 value (1,4,2);
insert into t1 value (1,4,3);
insert into t1 value (1,4,4);
insert into t1 value (1,4,4);
insert into t1 value (1,4,5);
insert into t1 value (1,4,5);


create index idx on t1(i1,i2,i3 desc);


set system parameters 'multi_range_optimization_limit=0';

select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3 limit 4;

select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3 desc limit 4;

set system parameters 'multi_range_optimization_limit=100';

select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3 limit 4;

select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3 desc limit 4;


-- non -covering index
alter table t1 add column i4 int default -1;

set system parameters 'multi_range_optimization_limit=0';
select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3 limit 4;

select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3 desc limit 4;

set system parameters 'multi_range_optimization_limit=100';
select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3 limit 4;

select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3 desc limit 4;

drop t1;

commit;
--+ holdcas off;
