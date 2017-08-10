--1. The name of FK can be specified on ALTER statement. 

create table x (i int primary key);
create table y (i int, j int);
alter table y add foreign key fk1 (j) references x (i);
select index_name, is_foreign_key from db_index where class_name='y';
alter table y drop constraint fk1;
select index_name, is_foreign_key from db_index where class_name='y';
drop table y;
drop table x;

--2. If a constraint's name (fk0 in the below) is specified additionally, we ignore it.

create table x (i int primary key);
create table y (i int, j int);
alter table y add constraint fk0 foreign key fk1 (j) references x (i);
select index_name, is_foreign_key from db_index where class_name='y';
alter table y drop constraint fk1;
select index_name, is_foreign_key from db_index where class_name='y';
drop table y;
drop table x;


--3. The name of FK can also be specified on CREATE statement.

create table x (i int primary key);
create table y (i int, j int, foreign key fk1 (j) references x (i));
create table z (i int, j int, constraint fk0 foreign key fk2 (j) references x (i));
select index_name, is_foreign_key from db_index where class_name='y';
select index_name, is_foreign_key from db_index where class_name='z';
alter table y drop constraint fk1;
alter table z drop constraint fk2;
select index_name, is_foreign_key from db_index where class_name='y';
select index_name, is_foreign_key from db_index where class_name='z';
drop table y, z;
drop table x;


