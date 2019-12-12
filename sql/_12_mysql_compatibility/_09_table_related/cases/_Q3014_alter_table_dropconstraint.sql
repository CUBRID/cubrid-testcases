--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1(id int primary key, a int);
insert into t1 values (1,1),(2,2),(3,3);
insert into t1 values (1,1);
alter table t1 drop primary key;
insert into t1 values (1,4);
select * from t1 order by a asc;
drop table t1;


create table t1(id int primary key, a int, unique key key1(a));
insert into t1 values (1,1),(2,2),(3,3);
insert into t1 values (4,1);
alter table t1 drop key key1;
insert into t1 values (4,1);
select * from t1 order by id asc;
drop table t1;

create table tb_group (group_id int primary key, group_name varchar(100)) ;
insert into tb_group values (1, 'g1');
insert into tb_group values (2, 'g2');
create table tb_emp (emp_id int primary key, emp_name varchar(100), group_id int,
	foreign key(group_id) references tb_group(group_id) 
) ;
insert into tb_emp values (1, 'e1', 1);
insert into tb_emp values (2, 'e2', 2);
insert into tb_emp values (1, 'e1', 1);
alter table tb_emp drop foreign key fk_tb_emp_group_id;
insert into tb_emp values (3, 'e3', 3);
select * from tb_emp order by 1,2,3;
drop table tb_emp;
drop table tb_group;


set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
