--create table of column with SYSDATETIME default value using 'create table like...' syntax


--TEST: error, time
create table c20(col time default SYSDATETIME);
create table clike like c20;
desc clike;
drop table c20;
drop table clike;


--TEST: error, date
create table c20(col date default SYSDATETIME);
create table clike like c20;
show columns in clike;
drop table c20;
drop table clike;


--TEST: error, timestamp
create table c20(col timestamp default SYSDATETIME);
create table clike like c20;
desc clike;
drop table c20;
drop table clike;


--TEST: error, datetime
create table c20(col datetime default SYSDATETIME);
create table clike like c20;
show columns in clike;
drop table c20;
drop table clike;
