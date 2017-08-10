create table tbl1 (a int primary key, b int); 
alter class tbl1 change column a a int; 
insert into tbl1(a, b) values(NULL, 1); 
drop table tbl1;

create table t1_add_default (a int primary key, b int); 
alter class t1_add_default change column a a int default 2; 
insert into t1_add_default(a, b) values(NULL, 1); 
drop table t1_add_default;

create table t1_delete_default (a int primary key default 1, b int); 
alter class t1_delete_default change column a a int; 
insert into t1_delete_default(a, b) values(NULL, 1); 
drop t1_delete_default;

create table t1_change_default (a int primary key default 1, b int); 
alter class t1_change_default change column a a int default 2; 
insert into t1_change_default(a, b) values(NULL, 1); 
drop t1_change_default;

create table t1_add_auto_increment (a int primary key, b int); 
alter class t1_add_auto_increment change column a a int auto_increment; 
insert into t1_add_auto_increment values(NULL,1);
select * from t1_add_auto_increment;
drop t1_add_auto_increment;

create table t1_delete_auto_increment (a int primary key auto_increment, b int); 
alter class t1_delete_auto_increment change column a a int; 
insert into t1_delete_auto_increment (a, b) values(NULL, 1); 
drop t1_delete_auto_increment;

