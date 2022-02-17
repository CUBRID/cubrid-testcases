drop if exists tx;
create table tx (tx int);
insert into tx values (7);

create view DBTIMEZONE as select tx from tx where tx is not null;
select * from DBTIMEZONE;
drop view DBTIMEZONE;

rename table tx as DBTIMEZONE;
alter table DBTIMEZONE change tx  DBTIMEZONE integer;
create view NONE as select DBTIMEZONE from DBTIMEZONE where DBTIMEZONE is not null;
select * from NONE;
drop view NONE;

rename table DBTIMEZONE as NONE;
alter table NONE change DBTIMEZONE NONE integer;
create view SESSIONTIMEZONE as select NONE from NONE where NONE is not null;
select * from SESSIONTIMEZONE;
drop view SESSIONTIMEZONE;

rename table NONE as SESSIONTIMEZONE;
alter table SESSIONTIMEZONE change NONE SESSION_TIMEZONE integer;
create view TIMEZONES as select SESSIONTIMEZONE from SESSION_TIMEZONE where SESSION_TIMEZONE is not null;
select * from TIMEZONES;
drop view TIMEZONES;

rename table SESSIONTIMEZONE as TIMEZONES;
alter table TIMEZONES change SESSIONTIMEZONE TIMEZONES integer;
create view DBTIMEZONE as select TIMEZONES from TIMEZONES where TIMEZONES is not null;
select * from DBTIMEZONE;
drop view DBTIMEZONE;

drop table TIMEZONES;
