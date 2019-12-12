--create table of column with SYSTIMESTAMP default value using 'create table like...' syntax


--TEST: error, time type
create table c17(col time default SYSTIMESTAMP);
create table clike like c17;
desc clike;
drop table c17;
drop table clike;


--TEST: error, date type
create table c17(col date default SYSTIMESTAMP);
create table clike like c17;
show columns in clike;
drop table c17;
drop table clike;


--TEST: timestamp type
create table c17(col timestamp default SYSTIMESTAMP);
create table clike like c17;
desc clike;
drop table c17;
drop table clike;


--TEST: datetime type
create table c17(col datetime default SYSTIMESTAMP);
create table clike like c17;
show columns in clike;
drop table c17;
drop table clike;
