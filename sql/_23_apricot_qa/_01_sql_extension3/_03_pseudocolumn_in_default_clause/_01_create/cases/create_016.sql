--TEST: create table of column with CURRENT_TIMESTAMP default value using 'create table like...' syntax


--TEST: error, time type
create table c16(col time default CURRENT_TIMESTAMP);
create table clike like c16;
desc clike;
drop table c16;
drop table clike;


--TEST: error, date type
create table c16(col date default CURRENT_TIMESTAMP);
create table clike like c16;
show columns in clike;
drop table c16;
drop table clike;


--TEST: timestamp type
create table c16(col timestamp default CURRENT_TIMESTAMP);
create table clike like c16;
desc clike;
drop table c16;
drop table clike;


--TEST: datetime type
create table c16(col datetime default CURRENT_TIMESTAMP);
create table clike like c16;
show columns in clike;
drop table c16;
drop table clike;
