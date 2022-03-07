drop if exists tx;
create table tx (tx int);
insert into tx values (7);

create view BUFFER as select tx from tx where tx is not null;
select * from BUFFER;
drop view BUFFER;
                    
rename table tx as BUFFER;
alter table BUFFER change tx  BUFFER integer;
create view CLOSE as select BUFFER from BUFFER where BUFFER is not null;
select * from CLOSE;
drop view CLOSE;

rename table BUFFER as CLOSE;
alter table CLOSE change BUFFER  CLOSE integer;
create view COMMENT as select CLOSE from CLOSE where CLOSE is not null;
select * from COMMENT;
drop view COMMENT;

rename table CLOSE as COMMENT;
alter table COMMENT change CLOSE  COMMENT integer;
create view CRITICAL as select COMMENT from COMMENT where COMMENT is not null;
select * from CRITICAL;
drop view CRITICAL;

rename table COMMENT as CRITICAL;
alter table CRITICAL change COMMENT  CRITICAL integer;
create view DBLINK as select CRITICAL from CRITICAL where CRITICAL is not null;
select * from DBLINK;
drop view DBLINK;

rename table CRITICAL as DBLINK;
alter table DBLINK change CRITICAL  DBLINK integer;
create view DBNAME as select DBLINK from DBLINK where DBLINK is not null;
select * from DBNAME;
drop view DBNAME;

rename table DBLINK as DBNAME;
alter table DBNAME change DBLINK  DBNAME integer;
create view DISK_SIZE as select DBNAME from DBNAME where DBNAME is not null;
select * from DISK_SIZE;
drop view DISK_SIZE;

rename table DBNAME as DISK_SIZE;
alter table DISK_SIZE change DBNAME  DISK_SIZE integer;
create view DONT_REUSE_OID as select DISK_SIZE from DISK_SIZE where DISK_SIZE is not null;
select * from DONT_REUSE_OID;
drop view DONT_REUSE_OID;

rename table DISK_SIZE as DONT_REUSE_OID;
alter table DONT_REUSE_OID change DISK_SIZE  DONT_REUSE_OID integer;
create view HOST as select DONT_REUSE_OID from DONT_REUSE_OID where DONT_REUSE_OID is not null;
select * from HOST;
drop view HOST;

rename table DONT_REUSE_OID as HOST;
alter table HOST change DONT_REUSE_OID  HOST integer;
create view INVISIBLE as select HOST from HOST where HOST is not null;
select * from INVISIBLE;
drop view INVISIBLE;

rename table HOST as INVISIBLE;
alter table INVISIBLE change HOST  INVISIBLE integer;
create view JOB as select INVISIBLE from INVISIBLE where INVISIBLE is not null;
select * from JOB;
drop view JOB;

rename table INVISIBLE as JOB;
alter table JOB change INVISIBLE  JOB integer;
create view NULLS as select JOB from JOB where JOB is not null;
select * from NULLS;
drop view NULLS;

rename table JOB as NULLS;
alter table NULLS change JOB  NULLS integer;
create view OPEN as select NULLS from NULLS where NULLS is not null;
select * from OPEN;
drop view OPEN;

rename table NULLS as OPEN;
alter table OPEN change NULLS  OPEN integer;
create view PATH as select OPEN from OPEN where OPEN is not null;
select * from PATH;
drop view PATH;

rename table OPEN as PATH;
alter table PATH change OPEN  PATH integer;
create view PERCENTILE_CONT as select PATH from PATH where PATH is not null;
select * from PERCENTILE_CONT;
drop view PERCENTILE_CONT;

rename table PATH as PERCENTILE_CONT;
alter table PERCENTILE_CONT change PATH  PERCENTILE_CONT integer;
create view PERCENTILE_DISC as select PERCENTILE_CONT from PERCENTILE_CONT where PERCENTILE_CONT is not null;
select * from PERCENTILE_DISC;
drop view PERCENTILE_DISC;

rename table PERCENTILE_CONT as PERCENTILE_DISC;
alter table PERCENTILE_DISC change PERCENTILE_CONT  PERCENTILE_DISC integer;
create view PORT as select PERCENTILE_DISC from PERCENTILE_DISC where PERCENTILE_DISC is not null;
select * from PORT;
drop view PORT;

rename table PERCENTILE_DISC as PORT;
alter table PORT change PERCENTILE_DISC  PORT integer;
create view PROPERTIES as select PORT from PORT where PORT is not null;
select * from PROPERTIES;
drop view PROPERTIES;

rename table PORT as PROPERTIES;
alter table PROPERTIES change PORT  PROPERTIES integer;
create view QUEUES as select PROPERTIES from PROPERTIES where PROPERTIES is not null;
select * from QUEUES;
drop view QUEUES;

rename table PROPERTIES as QUEUES;
alter table QUEUES change PROPERTIES  QUEUES integer;
create view RESPECT as select QUEUES from QUEUES where QUEUES is not null;
select * from RESPECT;
drop view RESPECT;

rename table QUEUES as RESPECT;
alter table RESPECT change QUEUES  RESPECT integer;
create view SECTIONS as select RESPECT from RESPECT where RESPECT is not null;
select * from SECTIONS;
drop view SECTIONS;

rename table RESPECT as SECTIONS;
alter table SECTIONS change RESPECT  SECTIONS integer;
create view SERVER as select SECTIONS from SECTIONS where SECTIONS is not null;
select * from SERVER;
drop view SERVER;

rename table SECTIONS as SERVER;
alter table SERVER change SECTIONS  SERVER integer;
create view THREADS as select SERVER from SERVER where SERVER is not null;
select * from THREADS;
drop view THREADS;

rename table SERVER as THREADS;
alter table THREADS change SERVER  THREADS integer;
create view TRAN as select THREADS from THREADS where THREADS is not null;
select * from TRAN;
drop view TRAN;

rename table THREADS as TRAN;
alter table TRAN change THREADS  TRAN integer;
create view VISIBLE as select TRAN from TRAN where TRAN is not null;
select * from VISIBLE;
drop view VISIBLE;

rename table TRAN as VISIBLE;
alter table VISIBLE change TRAN  VISIBLE integer;
create view WITHIN as select VISIBLE from VISIBLE where VISIBLE is not null;
select * from WITHIN;
drop view WITHIN;

rename table VISIBLE as WITHIN;
alter table WITHIN change VISIBLE  WITHIN integer;
create view BUFFER as select WITHIN from WITHIN where WITHIN is not null;
select * from BUFFER;
drop view BUFFER;
       
drop table WITHIN;

