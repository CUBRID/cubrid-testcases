--create table of column with USER default value using 'create table like...' syntax


--TEST: char(n)
create table c21(col char(20) default USER);
create table clike like c21;
desc clike;
drop table c21;
drop table clike;


--TEST: varchar
create table c21(col char varying(20) default USER);
create table clike like c21;
show columns in clike;
drop table c21;
drop table clike;


--TEST: string
create table c21(col string default USER);
create table clike like c21;
desc clike;
drop table c21;
drop table clike;


--TEST: error, nchar(n)
create table c21(col nchar(20) default USER);
create table clike like c21;
show columns in clike;
drop table c21;
drop table clike;


--TEST: error, nchar varying
create table c21(col nchar varying(20) default USER);
create table clike like c21;
show columns in clike;
drop table c21;
drop table clike;
