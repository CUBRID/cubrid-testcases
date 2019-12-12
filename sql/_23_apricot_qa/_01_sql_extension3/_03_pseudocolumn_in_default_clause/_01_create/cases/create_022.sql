--create table of column with CURRENT_USER default value using 'create table like...' syntax

create table c22(col char(20) default CURRENT_USER);
create table clike like c22;
desc clike;
drop table c22;
drop table clike;


create table c22(col char varying(20) default CURRENT_USER);
create table clike like c22;
show columns in clike;
drop table c22;
drop table clike;


create table c22(col string default CURRENT_USER);
create table clike like c22;
desc clike;
drop table c22;
drop table clike;


create table c22(col nchar(20) default CURRENT_USER);
create table clike like c22;
show columns in clike;
drop table c22;
drop table clike;


create table c22(col nchar varying(20) default CURRENT_USER);
create table clike like c22;
show columns in clike;
drop table c22;
drop table clike;
