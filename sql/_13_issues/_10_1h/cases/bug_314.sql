create table g1 (a int primary key unique not null default 0);
create table g2 (a int primary key unique default 0 not null);
create table g3 (a int primary key not null unique default 0);
create table g4 (a int primary key default 0 unique not null);
create table g5 (a int primary key not null default 0 unique);
create table g6 (a int primary key default 0 not null unique);
drop table g1, g2, g3, g4, g5, g6;

create table g1 (a int unique primary key not null default 0);
create table g2 (a int unique primary key default 0 not null);
create table g3 (a int not null primary key unique default 0);
create table g4 (a int default 0 primary key unique not null);
create table g5 (a int not null primary key default 0 unique);
create table g6 (a int default 0 primary key not null unique);
drop table g1, g2, g3, g4, g5, g6;

create table g1 (a int unique not null primary key default 0);
create table g2 (a int unique default 0 primary key not null);
create table g3 (a int not null unique primary key default 0);
create table g4 (a int default 0 unique primary key not null);
create table g5 (a int not null default 0 primary key unique);
create table g6 (a int default 0 not null primary key unique);
drop table g1, g2, g3, g4, g5, g6;

create table g1 (a int unique not null default 0 primary key);
create table g2 (a int unique default 0 not null primary key);
create table g3 (a int not null unique default 0 primary key);
create table g4 (a int default 0 unique not null primary key);
create table g5 (a int not null default 0 unique primary key);
create table g6 (a int default 0 not null unique primary key);
drop table g1, g2, g3, g4, g5, g6;

create table g1 (a int shared 0 default 1);
create table g1 (a int default 1 shared 0);
create table g1 (a int shared 0 auto_increment);
create table g1 (a int auto_increment shared 0);
create table g1 (a int default 1 auto_increment);
create table g1 (a int auto_increment default 1);
create table g1 (a int shared 0 default 1 auto_increment);
create table g1 (a int shared 0 auto_increment default 1);
create table g1 (a int auto_increment shared 0 default 1);
create table g1 (a int default 1 shared 0 auto_increment);
create table g1 (a int auto_increment default 1 shared 0);
create table g1 (a int default 1 auto_increment shared 0);
drop table g1;

create table g1 (a int default 0 default 1);
create table g1 (a int shared 0 shared 1);
create table g1 (a int auto_increment auto_increment);
create table g1 (a int primary key primary key);
create table g1 (a int unique unique);
create table g1 (a int null not null);
drop table g1;

create table x (i int primary key shared 1);
create table x (i int unique shared 1);
drop table x;

create table x (i int primary key);
create table y (i int shared 1, foreign key (i) references x(i));
create table z (i int shared 1 foreign key references x(i));
drop table x;
drop table y;
drop table z;




