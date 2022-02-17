drop if exists t_colname;
create table t_colname (
BUFFER int,
CLOSE int,
COMMENT int,
CRITICAL int,
DBLINK int,
DBNAME int,
DISK_SIZE int,
DONT_REUSE_OID int,
HOST int,
INVISIBLE int,
JOB int,
NULLS int,
OPEN int,
PATH int,
PERCENTILE_CONT int,
PERCENTILE_DISC int,
PORT int,
PROPERTIES int,
QUEUES int,
RESPECT int,
SECTIONS int,
SERVER int,
THREADS int,
TRAN int,
VISIBLE int,
WITHIN int
);

create index BUFFER            on t_colname (BUFFER);
create index CLOSE             on t_colname (CLOSE);
create index COMMENT           on t_colname (COMMENT);
create index CRITICAL          on t_colname (CRITICAL);
create index DBLINK            on t_colname (DBLINK);
create index DBNAME            on t_colname (DBNAME);
create index DISK_SIZE         on t_colname (DISK_SIZE);
create index DONT_REUSE_OID    on t_colname (DONT_REUSE_OID);
create index HOST              on t_colname (HOST);
create index INVISIBLE         on t_colname (INVISIBLE);
create index JOB               on t_colname (JOB);
create index NULLS             on t_colname (NULLS);
create index OPEN              on t_colname (OPEN);
create index PATH              on t_colname (PATH);
create index PERCENTILE_CONT   on t_colname (PERCENTILE_CONT);
create index PERCENTILE_DISC   on t_colname (PERCENTILE_DISC);
create index PORT              on t_colname (PORT);
create index PROPERTIES        on t_colname (PROPERTIES);
create index QUEUES            on t_colname (QUEUES);
create index RESPECT           on t_colname (RESPECT);
create index SECTIONS          on t_colname (SECTIONS);
create index SERVER            on t_colname (SERVER);
create index THREADS           on t_colname (THREADS);
create index TRAN              on t_colname (TRAN);
create index VISIBLE           on t_colname (VISIBLE);
create index WITHIN            on t_colname (WITHIN);

insert into t_colname values ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 ,14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26);
select * from t_colname;
select BUFFER, CLOSE, COMMENT, CRITICAL, DBLINK, DBNAME,DISK_SIZE,DONT_REUSE_OID,
       HOST,INVISIBLE,JOB,NULLS,OPEN,PATH,PERCENTILE_CONT,PERCENTILE_DISC,PORT,PROPERTIES,
	   QUEUES,RESPECT,SECTIONS,SERVER,THREADS,TRAN,VISIBLE,WITHIN
from t_colname;

create table BUFFER (BUFFER int);  
create index BUFFER on BUFFER (BUFFER); 
insert into BUFFER select BUFFER from t_colname; 
select BUFFER from BUFFER;  
drop table BUFFER;

create table CLOSE (CLOSE int);  
create index CLOSE on CLOSE (CLOSE); 
insert into CLOSE select CLOSE from t_colname; 
select CLOSE from CLOSE;  
drop table CLOSE;

create table COMMENT (COMMENT int);  
create index COMMENT on COMMENT (COMMENT); 
insert into COMMENT select COMMENT from t_colname; 
select COMMENT from COMMENT;  
drop table COMMENT;

create table CRITICAL (CRITICAL int);
create index CRITICAL on CRITICAL (CRITICAL);
insert into CRITICAL select CRITICAL from t_colname;
select CRITICAL from CRITICAL; 
drop table CRITICAL;

create table DBLINK (DBLINK int);  
create index DBLINK on DBLINK (DBLINK); 
insert into DBLINK select DBLINK from t_colname; 
select DBLINK from DBLINK;  
drop table DBLINK;

create table DBNAME (DBNAME int);  
create index DBNAME on DBNAME (DBNAME); 
insert into DBNAME select DBNAME from t_colname; 
select DBNAME from DBNAME;  
drop table DBNAME;

create table DISK_SIZE (DISK_SIZE int);  
create index DISK_SIZE on DISK_SIZE (DISK_SIZE); 
insert into DISK_SIZE select DISK_SIZE from t_colname; 
select DISK_SIZE from DISK_SIZE;  
drop table DISK_SIZE;

create table DONT_REUSE_OID (DONT_REUSE_OID int);  
create index DONT_REUSE_OID on DONT_REUSE_OID (DONT_REUSE_OID); 
insert into DONT_REUSE_OID select DONT_REUSE_OID from t_colname; 
select DONT_REUSE_OID from DONT_REUSE_OID;  
drop table DONT_REUSE_OID;

create table HOST (HOST int);  
create index HOST on HOST (HOST); 
insert into HOST select HOST from t_colname; 
select HOST from HOST;  
drop table HOST;

create table INVISIBLE (INVISIBLE int);  
create index INVISIBLE on INVISIBLE (INVISIBLE); 
insert into INVISIBLE select INVISIBLE from t_colname; 
select INVISIBLE from INVISIBLE;  
drop table INVISIBLE;

create table JOB (JOB int);  
create index JOB on JOB (JOB); 
insert into JOB select JOB from t_colname; 
select JOB from JOB;  
drop table JOB;

create table NULLS (NULLS int);  
create index NULLS on NULLS (NULLS); 
insert into NULLS select NULLS from t_colname; 
select NULLS from NULLS;  
drop table NULLS;

create table OPEN (OPEN int);  
create index OPEN on OPEN (OPEN); 
insert into OPEN select OPEN from t_colname; 
select OPEN from OPEN;  
drop table OPEN;

create table PATH (PATH int);  
create index PATH on PATH (PATH); 
insert into PATH select PATH from t_colname; 
select PATH from PATH;  
drop table PATH;

create table PERCENTILE_CONT (PERCENTILE_CONT int);  
create index PERCENTILE_CONT on PERCENTILE_CONT (PERCENTILE_CONT); 
insert into PERCENTILE_CONT select PERCENTILE_CONT from t_colname; 
select PERCENTILE_CONT from PERCENTILE_CONT;  
drop table PERCENTILE_CONT;

create table PERCENTILE_DISC (PERCENTILE_DISC int);
create index PERCENTILE_DISC on PERCENTILE_DISC (PERCENTILE_DISC); 
insert into PERCENTILE_DISC select PERCENTILE_DISC from t_colname; 
select PERCENTILE_DISC from PERCENTILE_DISC;  
drop table PERCENTILE_DISC;

create table PORT (PORT int);  
create index PORT on PORT (PORT); 
insert into PORT select PORT from t_colname; 
select PORT from PORT;  
drop table PORT;

create table PROPERTIES (PROPERTIES int);  
create index PROPERTIES on PROPERTIES (PROPERTIES); 
insert into PROPERTIES select PROPERTIES from t_colname; 
select PROPERTIES from PROPERTIES;  
drop table PROPERTIES;

create table QUEUES (QUEUES int);  
create index QUEUES on QUEUES (QUEUES); 
insert into QUEUES select QUEUES from t_colname; 
select QUEUES from QUEUES;  
drop table QUEUES;

create table RESPECT (RESPECT int);  
create index RESPECT on RESPECT (RESPECT); 
insert into RESPECT select RESPECT from t_colname; 
select RESPECT from RESPECT;  
drop table RESPECT;

create table SECTIONS (SECTIONS int);  
create index SECTIONS on SECTIONS (SECTIONS); 
insert into SECTIONS select SECTIONS from t_colname; 
select SECTIONS from SECTIONS;  
drop table SECTIONS;

create table SERVER (SERVER int);  
create index SERVER on SERVER (SERVER); 
insert into SERVER select SERVER from t_colname; 
select SERVER from SERVER;  
drop table SERVER;

create table THREADS (THREADS int);  
create index THREADS on THREADS (THREADS); 
insert into THREADS select THREADS from t_colname; 
select THREADS from THREADS;  
drop table THREADS;

create table TRAN (TRAN int);  
create index TRAN on TRAN (TRAN); 
insert into TRAN select TRAN from t_colname; 
select TRAN from TRAN;  
drop table TRAN;

create table VISIBLE (VISIBLE int);  
create index VISIBLE on VISIBLE (VISIBLE); 
insert into VISIBLE select VISIBLE from t_colname; 
select VISIBLE from VISIBLE;  
drop table VISIBLE;

create table WITHIN (WITHIN int);  
create index WITHIN on WITHIN (WITHIN); 
insert into WITHIN select WITHIN from t_colname; 
select WITHIN from WITHIN;  
drop table WITHIN;

drop table t_colname;
