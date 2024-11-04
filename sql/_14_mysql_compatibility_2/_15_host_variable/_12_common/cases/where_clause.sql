--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
-- index
create table t1 (i1 int,i2 int);
insert into t1 values(3,-1);
insert into t1 values(30,-1);
insert into t1 values(30,-1);
insert into t1 values(2,-1);
insert into t1 values(1,-1);
insert into t1 values(2,-1);

create index i_t1_i1 on t1(i1);


select * from t1 where i1=i2+31.0 order by 1;
	
prepare st from 'select * from t1 where i1=i2+?  order by 1';
execute st using 31.0;
deallocate prepare st;	

	
select /*+ recompile ordered */ * from t1 where i1=(select max(i1 + 0.0 ) from t1)  order by 1;
	
prepare st from 'select * from t1 where i1=(select max(i1 + ? ) from t1)  order by 1';
execute st using 0.0;
deallocate prepare st;	


select * from t1 where i1=(select max(i1 + 0.0 ) from t1) or i1=(select min(i1 + 0.0 ) from t1)  order by 1;

prepare st from 'select * from t1 where i1=(select max(i1 + ? ) from t1) or i1=(select min(i1 + ? ) from t1)  order by 1';
execute st using 0.0,0.0;
deallocate prepare st;	


select 1 from t1,table(set{i2}) as t(i) where i1 in set{t.i+2};

prepare st from 'select 1 from t1,table(set{i2}) as t(i) where i1 in set{t.i+?}';
execute st using 2.0;
deallocate prepare st;	

drop table t1;



-- no index
create table t1 (i1 int,i2 int);
insert into t1 values(3,-1);
insert into t1 values(30,-1);
insert into t1 values(30,-1);
insert into t1 values(2,-1);
insert into t1 values(1,-1);
insert into t1 values(2,-1);


select * from t1 where i1=i2+31.0 order by 1;
	
prepare st from 'select * from t1 where i1=i2+?  order by 1';
execute st using 31.0;
deallocate prepare st;	

	
select /*+ recompile ordered */ * from t1 where i1=(select max(i1 + 0.0 ) from t1)  order by 1;
	
prepare st from 'select * from t1 where i1=(select max(i1 + ? ) from t1)  order by 1';
execute st using 0.0;
deallocate prepare st;

select * from t1 where i1=(select max(i1 + 0.0 ) from t1) or i1=(select min(i1 + 0.0 ) from t1)  order by 1;

prepare st from 'select * from t1 where i1=(select max(i1 + ? ) from t1) or i1=(select min(i1 + ? ) from t1)  order by 1';
execute st using 0.0,0.0;
deallocate prepare st;	


select 1 from t1,table(set{i2}) as t(i) where i1 in set{t.i+2};

prepare st from 'select 1 from t1,table(set{i2}) as t(i) where i1 in set{t.i+?}';
execute st using 2.0;	

drop prepare st;
drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
