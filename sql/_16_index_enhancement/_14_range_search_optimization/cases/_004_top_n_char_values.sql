--+ holdcas on;
-- covering index - ascending index
create table t1 (i1 int, i2 int, s3 varchar(40),s4 varchar(40));

insert into t1 value (1,2,'1','zero');
insert into t1 value (1,2,'2','zero');
insert into t1 value (1,2,'3','zero');
insert into t1 value (1,2,'4','zero');
insert into t1 value (1,2,'4','zero');
insert into t1 value (1,2,'5','zero');
insert into t1 value (1,2,'6','zero');
       
	   
insert into t1 value (1,3,'1','zero');
insert into t1 value (1,3,'2','zero');
insert into t1 value (1,3,'3','zero');
insert into t1 value (1,3,'4','zero');
insert into t1 value (1,3,'5','zero');
insert into t1 value (1,3,'5','zero');
insert into t1 value (1,3,'6','zero');	
                   
				   
insert into t1 value (1,4,'1','zero');
insert into t1 value (1,4,'2','zero');
insert into t1 value (1,4,'3','zero');
insert into t1 value (1,4,'4','zero');
insert into t1 value (1,4,'4','zero');
insert into t1 value (1,4,'5','zero');
insert into t1 value (1,4,'5','zero');


create index idx on t1(i1,i2,s3,s4);


set system parameters 'multi_range_optimization_limit=0';

select * from t1 where i1 = 1 and i2 in (2,3,4) and s3 > '2' and s3 < '6' order by s3 limit 4;

set system parameters 'multi_range_optimization_limit=100';

select * from t1 where i1 = 1 and i2 in (2,3,4) and s3 > '2' and s3 < '6' order by s3 limit 4;


drop table t1;



commit;
--+ holdcas off;
