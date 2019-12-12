--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table tb_group (group_id int primary key, group_name varchar(100)) ;
create table tb_emp (emp_id int primary key, emp_name varchar(100), group_id int,
	foreign key(group_id) references tb_group(group_id) 
) ;
insert into tb_group values (1, 'group 1');
insert into tb_group values (2, 'group 2');
insert into tb_emp values (1, 'emp 1', null);
insert into tb_emp values (2, 'emp 2', 1);
insert into tb_emp values (3, 'emp 3', 2);
insert into tb_emp values (4, 'emp 4', 3);
update tb_emp set group_id=3 where emp_id=1;
drop table tb_emp;
drop table tb_group;


create table tb_group (group_id int primary key, group_name varchar(100));
create table tb_emp (emp_id int primary key, emp_name varchar(100) );
insert into tb_group values (1, 'group 1'),(2, 'group 2');
insert into tb_emp values (1, 'emp 1'),(2, 'emp 2'),(3, 'emp 3'),(4, 'emp 4');
alter table tb_emp add column group_id int foreign key references tb_group(group_id);
update tb_emp set group_id=3 where group_id is null;
insert into tb_emp values (5, 'emp 5', 1), (6, 'emp 6', 3);
insert into tb_emp values (7, 'emp 7', 1),(8, 'emp 8', 2);
delete from tb_group;
select * from tb_group order by group_id asc;
select * from tb_emp order by emp_id asc;
delete from tb_emp where group_id=1;
delete from tb_group where group_id=1;
drop table tb_group;
drop table tb_emp;
drop table tb_group;


create table tb_group (group_id int primary key, group_name varchar(100));
create table tb_emp (emp_id int primary key, emp_name varchar(100) );
alter table tb_emp add column group_id int not null foreign key references tb_group(group_id);
alter table tb_group add column charger_id int not null foreign key references tb_emp(emp_id);
insert into tb_group values (1, 'g1', null);
insert into tb_group values (1, 'g1', 1);
insert into tb_emp values (1, 'e1', null);
insert into tb_emp values (2, 'e2', 1);
drop table tb_emp;
drop table tb_group;
alter table tb_group drop FOREIGN KEY fk_tb_group_charger_id;
drop table tb_group;
drop table tb_emp;
drop table tb_group;


create table tb_group (group_id int primary key, group_name varchar(100));
create table tb_emp (emp_id int primary key, emp_name varchar(100) );
alter table tb_emp add column group_id int not null foreign key references tb_group(group_id) ON DELETE SET NULL;
alter table tb_emp add column group_id int null foreign key references tb_group(group_id) ON DELETE SET NULL;
insert into tb_group values (1, 'g1');
insert into tb_group values (2, 'g2');
insert into tb_emp values (1, 'e1', 1);
insert into tb_emp values (2, 'e2', 1);
insert into tb_emp values (3, 'e3', 1);
insert into tb_emp values (4, 'e4', 1);
insert into tb_emp values (5, 'e5', 1);
insert into tb_emp values (6, 'e6', 1);
insert into tb_emp values (7, 'e7', 2);
insert into tb_emp values (8, 'e8', 2);
insert into tb_emp values (9, 'e9', 2);
insert into tb_emp values (10, 'e10', 2);
insert into tb_emp values (11, 'e11', 2);
insert into tb_emp values (12, 'e12', 2);
delete from tb_group where group_id=2;
select * from tb_emp order by emp_id asc;
delete from tb_group where group_id=1;
select * from tb_emp order by emp_id asc;
drop table tb_emp;
drop table tb_group;

create table tb_group (group_id int primary key, group_name varchar(100));
create table tb_emp (emp_id int primary key, emp_name varchar(100) );
alter table tb_emp add column group_id int not null foreign key references tb_group(group_id) ON UPDATE SET NULL;
alter table tb_emp add column group_id int null foreign key references tb_group(group_id) ON UPDATE SET NULL ON DELETE SET NULL;
insert into tb_group values (1, 'g1');
insert into tb_group values (2, 'g2');
insert into tb_emp values (1, 'e1', 1);
insert into tb_emp values (2, 'e2', 1);
insert into tb_emp values (3, 'e3', 1);
insert into tb_emp values (4, 'e4', 1);
insert into tb_emp values (5, 'e5', 1);
insert into tb_emp values (6, 'e6', 1);
insert into tb_emp values (7, 'e7', 2);
insert into tb_emp values (8, 'e8', 2);
insert into tb_emp values (9, 'e9', 2);
insert into tb_emp values (10, 'e10', 2);
insert into tb_emp values (11, 'e11', 2);
insert into tb_emp values (12, 'e12', 2);
update tb_group set group_id=3 where group_id=2;
select * from tb_emp order by emp_id asc;
update tb_group set group_id=4 where group_id=1;
select * from tb_emp order by emp_id asc;
drop table tb_emp;
drop table tb_group;

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
