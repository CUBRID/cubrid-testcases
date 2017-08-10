create table a01(id short primary key auto_increment);
insert into a01 values(null), (null), (null);
desc a01;
alter table a01 add column col3 timestamp default CURRENT_TIMESTAMP ;
desc a01;
drop table a01;

create table a01(id short primary key auto_increment);
insert into a01 values(null), (null), (null);
alter table a01 add column col3 timestamp default CURRENT_TIMESTAMP ;
select id, if (col3 is not null, 'OK', 'NOK') from a01 order by id;
drop a01;

create table a01(id short primary key auto_increment);
insert into a01 values(null), (null), (null);
alter table a01 add column col3 timestamp default UNIX_TIMESTAMP() ;
select id, if (col3 is not null, 'OK', 'NOK') from a01 order by id;
drop a01;

create table a01(id short primary key auto_increment);
insert into a01 values(null), (null), (null);
alter table a01 add column col3 datetime default SYSDATETIME ;
select id, if (col3 is not null, 'OK', 'NOK') from a01 order by id;
drop a01;

create table a01(id short primary key auto_increment);
insert into a01 values(null), (null), (null);
alter table a01 add column col3 datetime default now() ;
select id, if (col3 is not null, 'OK', 'NOK') from a01 order by id;
drop a01;

create table a01(id short primary key auto_increment);
insert into a01 values(null), (null), (null);
alter table a01 add column col3 date default current_date ;
select id, if (col3 is not null, 'OK', 'NOK') from a01 order by id;
drop a01;

create table a01(id short primary key auto_increment);
insert into a01 values(null), (null), (null);
alter table a01 add column col3 varchar(256) default CURRENT_USER ;
select id, if (col3 is not null, 'OK', 'NOK') from a01 order by id;
drop a01;
