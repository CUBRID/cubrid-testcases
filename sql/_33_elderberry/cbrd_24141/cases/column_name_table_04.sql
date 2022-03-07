drop if exists t_colname;

create table t_colname (
DBTIMEZONE int,
NONE int,
SESSIONTIMEZONE int,
TIMEZONES int,
);

create index DBTIMEZONE               on t_colname (DBTIMEZONE);                
create index NONE              on t_colname (NONE);
create index SESSIONTIMEZONE         on t_colname (SESSIONTIMEZONE);
create index TIMEZONES             on t_colname (TIMEZONES);

insert into t_colname values (1, 2, 3, 4);
select * from t_colname;
select DBTIMEZONE, NONE, SESSIONTIMEZONE, TIMEZONES
from t_colname;


create table DBTIMEZONE (DBTIMEZONE int);  
create index DBTIMEZONE on DBTIMEZONE (DBTIMEZONE); 
insert into DBTIMEZONE select DBTIMEZONE from t_colname; 
select DBTIMEZONE from DBTIMEZONE; 
drop table DBTIMEZONE;

create table NONE (NONE int);  
create index NONE on NONE (NONE); 
insert into NONE select NONE from t_colname; 
select NONE from NONE; 
drop table NONE;

create table SESSIONTIMEZONE (SESSIONTIMEZONE int);  
create index SESSIONTIMEZONE on SESSIONTIMEZONE (SESSIONTIMEZONE);
insert into SESSIONTIMEZONE select SESSIONTIMEZONE from t_colname; 
select SESSIONTIMEZONE from SESSIONTIMEZONE; 
drop table SESSIONTIMEZONE;

create table TIMEZONES (TIMEZONES int);  
create index TIMEZONES on TIMEZONES (TIMEZONES);
insert into TIMEZONES select TIMEZONES from t_colname; 
select TIMEZONES from TIMEZONES; 
drop table TIMEZONES;


drop table t_colname;
