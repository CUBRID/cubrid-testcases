create table t1 (c char(10), unique key uk1 (c)); 
create table t2 (c char(10), unique key uk2 (c)); 
create table t3 (c char(10), unique key uk3(1)); 
create table t4 (c char(10), unique key uk4 (c(1))); 
create table t5 (a int, b int, unique key uk5 (a,b)); 
create table t6 (a int, b int, unique key uk6 (1,2)); 
create table t7 (c char(10), unique key uk7(c) DEFERRABLE); 
create table t8 (c char(10), unique key uk8 (c) INITIALLY DEFERRED); 
create table t9 (a int, b int, unique key uk9 (1,2) DEFERRABLE); 

drop table t1;
drop table t2;
drop table t5;
drop table t7;
drop table t8;
