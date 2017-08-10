--create table of column with UNIX_TIMESTAMP() default value using 'create table like...' syntax


--TEST: error, time
create table c18(col time default UNIX_TIMESTAMP());
create table clike like c18;
desc clike;
drop table c18;
drop table clike;


--TEST: error, date
create table c18(col date default UNIX_TIMESTAMP());
create table clike like c18;
show columns in clike;
drop table c18;
drop table clike;


--TEST: timestamp
create table c18(col timestamp default UNIX_TIMESTAMP());
create table clike like c18;
desc clike;
drop table c18;
drop table clike;


--TEST: datetime
create table c18(col datetime default UNIX_TIMESTAMP());
create table clike like c18;
show columns in clike;
drop table c18;
drop table clike;
