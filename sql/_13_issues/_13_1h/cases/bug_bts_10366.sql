drop if exists t1,t2; 

create table t1 ( b int ) ; 
create table t2 ( b int ) ; 

--ERROR: System error (generate inst_num or orderby_num) in ../../src/parser/xasl_generation.c (line: 6889)
delete t1,t2 from t1 left outer join t2 on t1.b=t2.b and rownum < 100;

delete t1,t2 from t1 right join t2 on t1.b=t2.b and rownum < 100;

delete t1,t2 from t1,t2 where  t1.b=t2.b and rownum < 100 and rownum > 80;

delete t1,t2 from t1 left outer join t2 on t1.b=t2.b and rownum < 100 left outer join db_class t3 on t1.b=t2.b and rownum < 100;

delete t1.* ,t2.* from t1 left outer join t2 on t1.b=t2.b and rownum < 100 left outer join db_class t3 on t1.b=t2.b and rownum < 100;

delete t1.* ,t2.* from t1 left outer join t2 on t1.b=t2.b;

delete t1.* ,t2.* from t1 inner join t2 on t1.b=t2.b;

delete t1,t2 from t1 inner join t2 on t1.b=t2.b and rownum < 100;

delete t1,t2 from t1 inner join t2 on t1.b=t2.b ;

drop if exists t1,t2; 

create table t1 ( b bigint ) partition by hash(b) partitions 2; 
create table t2 ( b bigint ) partition by hash(b) partitions 2;  

delete t1,t2 from t1 left outer join t2 on t1.b=t2.b and rownum < 100;

delete t1,t2 from t1 right join t2 on t1.b=t2.b and rownum < 100;

delete t1,t2 from t1,t2 where  t1.b=t2.b and rownum < 100 and rownum > 80;

delete t1,t2 from t1 left outer join t2 on t1.b=t2.b and rownum < 100 left outer join db_class t3 on t1.b=t2.b and rownum < 100;

delete t1.* ,t2.* from t1 left outer join t2 on t1.b=t2.b and rownum < 100 left outer join db_class t3 on t1.b=t2.b and rownum < 100;

delete t1,t2 from t1 inner join t2 on t1.b=t2.b and rownum < 100;

delete t1,t2 from t1 inner join t2 on t1.b=t2.b ;

drop if exists t1,t2; 


