DROP TABLE IF EXISTS CLOSE;
create table CLOSE ( col_id varchar(10), col1 varchar(10) );
insert into CLOSE values ( 'open', 'close' );
truncate table CLOSE;
select count (*) from CLOSE ;
drop CLOSE;

DROP TABLE IF EXISTS OPEN; 
create table OPEN ( col_id varchar(10), col1 varchar(10) ); 
insert into OPEN values ( 'open', 'close' ); 
truncate table OPEN; 
select count (*) from OPEN ; 
drop OPEN;

DROP TABLE IF EXISTS OPEN;
create table open (close int);
insert into open (close) values (0);
select close from open;

rename table open to close;
alter table close add column open char(10) default 'open';
create index open on close(open, close);
select * from close;
desc close;
show create table close;
show full columns from close;

create view open as select close from close;
select close from open;
show create view open;

drop view open;
drop table if exists close, open;


