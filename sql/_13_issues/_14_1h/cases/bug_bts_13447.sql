drop if exists tb1;
drop if exists tb2;
create table tb1 (a int primary key  auto_increment, grade int);
create table tb2 (a int auto_increment, grade int);
create trigger tgr3 deferred insert on tb1 if(grade > 100) execute insert into tb2(grade) values(obj.grade);
autocommit off;
insert into tb1(grade) values(120);
drop tb1;
create table tb1 (a int primary key auto_increment, grade int default 60);
insert into tb1(grade) values(110);
select * from tb1;
commit;

drop table tb1;
drop table tb2;
create table tb1 (a int primary key  auto_increment, grade int);
create table tb2 (a int auto_increment, grade int);
create trigger tgr3 deferred insert on tb1 if(grade > 100) execute insert into tb2(grade) values(obj.grade);
autocommit off;
insert into tb1(grade) values(120);
drop tb1;
commit;

autocommit on;
drop table tb2;
create table tb1 (a int primary key  auto_increment, grade int);
create table tb2 (a int auto_increment, grade int);
create trigger tgr3 deferred insert on tb1 if(grade > 100) execute insert into tb2(grade) values(obj.grade);
autocommit off; 
insert into tb1(grade) values(120);
drop trigger tgr3
create trigger tgr3 deferred insert on tb1 if(grade > 90) execute insert into tb2(grade) values(obj.grade);
insert into tb1(grade) values(110);
select * from tb1;
commit;

autocommit on;
drop table tb1;
drop table tb2;
autocommit off;
create table tb1 (a int primary key  auto_increment, grade int);
create table tb2 (a int auto_increment, grade int);
create trigger tgr3 deferred insert on tb1 if(grade > 100) execute insert into tb2(grade) values(obj.grade);
insert into tb1(grade) values(120);
drop tb1;
create table tb1 (a int primary key auto_increment, grade int default 60);
insert into tb1(grade) values(110);
select * from tb1;
commit;

drop table tb1;
drop table tb2;
commit;
