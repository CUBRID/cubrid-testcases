-- covering index - ascending index
--+ holdcas on;

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

create index  idx on t1(i1,i2,i3);



create table t2 (i1 int, i2 int, i3 int);

insert into t2 value (1,2,1);
insert into t2 value (1,2,2);
insert into t2 value (1,2,3);
insert into t2 value (1,2,4);
insert into t2 value (1,2,4);
insert into t2 value (1,2,5);
insert into t2 value (1,2,6);
        
		
insert into t2 value (1,3,1);
insert into t2 value (1,3,2);
insert into t2 value (1,3,3);
insert into t2 value (1,3,4);
insert into t2 value (1,3,5);
insert into t2 value (1,3,5);
insert into t2 value (1,3,6);	
            
			
insert into t2 value (1,4,1);
insert into t2 value (1,4,2);
insert into t2 value (1,4,3);
insert into t2 value (1,4,4);
insert into t2 value (1,4,4);
insert into t2 value (1,4,5);
insert into t2 value (1,4,5);

create index  idx2 on t2(i1,i2,i3);




set system parameters 'multi_range_optimization_limit=0';


-- uncorrelated subquery  --- 1
select /* + recompile */ * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 and i2 = (select max (i2) from t2 ) order by i3 limit 4;

--uncorrelated subquery  --- 2
select /* + recompile */ * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 and i2 = (select max (i2) from t1 ) order by i3 limit 4;

--correlated subquery  --- 1
select /* + recompile */ * from t1 as t1_c where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 and i2 = (select max (i2) from t1 where i3>t1_c.i2) order by i3 limit 4;

set system parameters 'multi_range_optimization_limit=100';


-- uncorrelated subquery  --- 1
select /* + recompile */ * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 and i2 = (select max (i2) from t2 ) order by i3 limit 4;

--uncorrelated subquery  --- 2
select /* + recompile */ * from t1 where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 and i2 = (select max (i2) from t1 ) order by i3 limit 4;

--correlated subquery  --- 1
select /* + recompile */ * from t1 as t1_c where i1 = 1 and i2 in (2,3,4) and i3 > 2 and i3 < 6 and i2 = (select max (i2) from t1 where i3>t1_c.i2) order by i3 limit 4;



drop t1;
drop t2;

commit;

--+ holdcas off;

