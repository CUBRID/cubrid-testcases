create table t(i int auto_increment default 5);

create table t0(i int auto_increment,j int);
alter table t0 alter column i set default 5;

create table t1 (x int auto_increment default 100);

create table t2 (x int);
alter table t2 add column x int auto_increment default 100;

create table t3 (x int auto_increment);
alter table t3 alter column x set default 100;

create table t4 (x int auto_increment);
alter TABLE t4 add column z int, alter column x SET DEFAULT 100;

create table t5 (x int, y int AUTO_INCREMENT);
alter TABLE t5 alter column x SET DEFAULT 100, alter column y set DEFAULT 100;

create table t6 (x int shared 3);
alter table t6 alter column x set default 100;


drop t0;
drop t2;
drop t3;
drop t4;
drop t5;
drop t6;
