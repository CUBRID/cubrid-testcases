--create table of column with SYSDATE default value using 'create table like...' syntax


--TEST: error, time
create table c19(col time default SYSDATE);
create table clike like c19;
desc clike;
drop table c19;
drop table clike;


--TEST: date
create table c19(col date default SYSDATE);
create table clike like c19;
show columns in clike;
drop table c19;
drop table clike;


--TEST: timestamp
create table c19(col timestamp default SYSDATE);
create table clike like c19;
desc clike;
drop table c19;
drop table clike;


--TEST: datetime
create table c19(col datetime default SYSDATE);
create table clike like c19;
show columns in clike;
drop table c19;
drop table clike;
