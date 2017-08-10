--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1(a int primary key, b int, unique key(b));
rename table t1 to t2;
create table t1(a int, b int);
insert into t1 values (1,1);
insert into t1 values (1,2);
insert into t1 values (2,1);
insert into t2 values (1,1);
insert into t2 values (1,2);
insert into t2 values (2,1);
select * from t1 order by a asc ,b asc;
select * from t2 order by a asc, b asc;
drop table t1;
drop table t2;

create table t1(a int primary key, b int, unique key uk1(b));
rename table t1 to t2;
create table t1(a int, b int);
insert into t1 values (1,1);
insert into t1 values (1,2);
insert into t1 values (2,1);
insert into t2 values (1,1);
insert into t2 values (1,2);
insert into t2 values (2,1);
select * from t1 order by a asc ,b asc;
select * from t2 order by a asc, b asc;
drop table t1;
drop table t2;


create table tb_group (group_id int primary key, group_name varchar(100)) ;
create table tb_emp (emp_id int primary key, emp_name varchar(100), group_id int,
	foreign key(group_id) references tb_group(group_id) 
);
insert into tb_group values (1, 'g1');
insert into tb_group values (2, 'g2');
insert into tb_emp values (1, 'e1', 1);
insert into tb_emp values (2, 'e2', 2);
rename table tb_group to tb_group_new;
insert into tb_emp values (3, 'e3', 1);
insert into tb_emp values (4, 'e4', 2);
insert into tb_emp values (5, 'e5', 3);
insert into tb_group_new values (3, 'g3');
insert into tb_emp values (5, 'e5', 3);
select * from tb_emp order by emp_id asc;
select * from tb_group_new order by group_id asc;
drop table tb_emp;
drop table tb_group;
drop table tb_group_new;

create table tb_group (group_id int primary key, group_name varchar(100)) ;
create table tb_emp (emp_id int primary key, emp_name varchar(100), group_id int,
	foreign key(group_id) references tb_group(group_id) 
);
alter table tb_group add column charger_id int foreign key references tb_emp(emp_id) after group_name;
rename table tb_group to tb_group_new;
alter table tb_group_new drop column charger_id;
drop table tb_emp;
drop table tb_group_new;

create table t1 (a int);
create table t2 (a int);
rename table t1 to t1_new, t2 to t2_new;
rename table t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new,t1_new to t1, t1 to t1_new;
drop table t1;
drop table t2;
drop table t1_new;
drop table t2_new;

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
