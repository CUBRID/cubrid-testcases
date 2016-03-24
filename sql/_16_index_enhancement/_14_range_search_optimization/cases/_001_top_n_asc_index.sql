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


create index idx1 on t1(i1,i2,i3);


set system parameters 'multi_range_optimization_limit=0';

select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3 limit 4;

set system parameters 'multi_range_optimization_limit=100';

select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3,i2 limit 4;


-- non -covering index
alter table t1 add column i4 int default -1;

insert into t1 values (1,2,4,0);
insert into t1 values (1,3,4,0);
insert into t1 values (1,3,4,0);
insert into t1 values (1,4,4,0);


set system parameters 'multi_range_optimization_limit=0';
select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3 limit 4;

select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3 desc limit 4;

-- key limit reset == false
select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 and i4 <> 0 order by i3 desc limit 4;

set system parameters 'multi_range_optimization_limit=100';
select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3,i2 limit 4;

select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 order by i3 desc,i2 limit 4;

-- key limit reset == false
select * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 and i4 <> 0 order by i3 desc limit 4;


drop t1;



create table t (i1 int, i2 int, i3 int);

create index idx3 on t(i1, i2 desc);
create index idx4 on t(i1, i2 desc, i3);

insert into t values  (0,0,0), (0,1,1), (0,2,2), (0,3,3), (0,4,4);
insert into t values (1,0,10),(1,1,11),(1,2,12),(1,3,13),(1,4,14);
insert into t values (2,0,20),(2,1,21),(2,2,22),(2,3,23),(2,4,24);
insert into t values (3,0,30),(3,1,31),(3,2,32),(3,3,33),(3,4,34);
insert into t values (4,0,40),(4,1,41),(4,2,42),(4,3,43),(4,4,44);


set system parameters 'multi_range_optimization_limit=0';

select /*+ recompile */ * from t where i1 in (1,3) order by i2 desc limit 2;

select /*+ recompile */ * from t where i1 in (1,3) and i2 != 4 order by i2 desc limit 2;

select /*+ recompile */ t.*, i3 mod 2 from t where i1 in (1,2,3) and i3 mod 2 > 0 order by i2 desc limit 5;

select /*+ recompile */ * from t where i1 in (1,3) and i1+i2 != 4 order by i2 desc limit 2;

select /*+ recompile */ * from t where i1 in (1,3) and i1+i2 = 4 order by i2 desc limit 2;

select /*+ recompile */ t.*, concat_ws('.',i1,i2) from t where i1 in (1,3) and concat_ws('.',i1,i2) < '3.3' order by i2 desc limit 3;


set system parameters 'multi_range_optimization_limit=100';

select /*+ recompile */ * from t where i1 in (1,3) order by i2 desc limit 2;

select /*+ recompile */ * from t where i1 in (1,3) and i2 != 4 order by i2 desc limit 2;

select /*+ recompile */ t.*, i3 mod 2 from t where i1 in (1,2,3) and i3 mod 2 > 0 order by i2 desc limit 5;

select /*+ recompile */ * from t where i1 in (1,3) and i1+i2 != 4 order by i2 desc limit 2;

select /*+ recompile */ * from t where i1 in (1,3) and i1+i2 = 4 order by i2 desc limit 2;

select /*+ recompile */ t.*, concat_ws('.',i1,i2) from t where i1 in (1,3) and concat_ws('.',i1,i2) < '3.3' order by i2 desc limit 3;


drop table t;



commit;
--+ holdcas off;
