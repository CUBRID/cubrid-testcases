drop if exists tx;
create table tx (tx int);
insert into tx values (7);

create view AES as select tx from tx where tx is not null;
select * from AES;
drop view AES;

rename table tx as AES;
alter table AES change tx  AES integer;
create view ARIA as select AES from AES where AES is not null;
select * from ARIA;
drop view ARIA;

rename table AES as ARIA;
alter table ARIA change AES ARIA integer;
create view BENCHMARK as select ARIA from ARIA where ARIA is not null;
select * from BENCHMARK;
drop view BENCHMARK;

rename table ARIA as BENCHMARK;
alter table BENCHMARK change ARIA BENCHMARK integer;
create view EMPTY as select BENCHMARK from BENCHMARK where BENCHMARK is not null;
select * from EMPTY;
drop view EMPTY;

rename table BENCHMARK as EMPTY;
alter table EMPTY change BENCHMARK EMPTY integer;
create view ENCRYPT as select EMPTY from EMPTY where EMPTY is not null;
select * from ENCRYPT;
drop view ENCRYPT;


rename table EMPTY as ENCRYPT;
alter table ENCRYPT change EMPTY ENCRYPT integer;
create view ERROR as select ENCRYPT from ENCRYPT where ENCRYPT is not null;
select * from ERROR;
drop view ERROR;

rename table ENCRYPT as ERROR;
alter table ERROR change ENCRYPT ERROR integer;
create view NESTED as select ERROR from ERROR where ERROR is not null;
select * from NESTED;
drop view NESTED;

rename table ERROR as NESTED;
alter table NESTED change ERROR NESTED integer;
create view ONLINE as select NESTED from NESTED where NESTED is not null;
select * from ONLINE;
drop view ONLINE;


rename table NESTED as ONLINE;
alter table ONLINE change NESTED ONLINE integer;
create view ORDINALITY as select ONLINE from ONLINE where ONLINE is not null;
select * from ORDINALITY;
drop view ORDINALITY;

rename table ONLINE as ORDINALITY;
alter table ORDINALITY change ONLINE ORDINALITY integer;
create view PARALLEL as select ORDINALITY from ORDINALITY where ORDINALITY is not null;
select * from PARALLEL;
drop view PARALLEL;

rename table ORDINALITY as PARALLEL;
alter table PARALLEL change ORDINALITY PARALLEL integer;
create view REGEXP_COUNT as select PARALLEL from PARALLEL where PARALLEL is not null;
select * from REGEXP_COUNT;
drop view REGEXP_COUNT;

rename table PARALLEL as REGEXP_COUNT;
alter table REGEXP_COUNT change PARALLEL REGEXP_COUNT integer;
create view REGEXP_INSTR as select REGEXP_COUNT from REGEXP_COUNT where REGEXP_COUNT is not null;
select * from REGEXP_INSTR;
drop view REGEXP_INSTR;

rename table REGEXP_COUNT as REGEXP_INSTR;
alter table REGEXP_INSTR change REGEXP_COUNT REGEXP_INSTR integer;
create view REGEXP_LIKE as select REGEXP_INSTR from REGEXP_INSTR where REGEXP_INSTR is not null;
select * from REGEXP_LIKE;
drop view REGEXP_LIKE;

rename table REGEXP_INSTR as REGEXP_LIKE;
alter table REGEXP_LIKE change REGEXP_INSTR REGEXP_LIKE integer;
create view REGEXP_REPLACE as select REGEXP_LIKE from REGEXP_LIKE where REGEXP_LIKE is not null;
select * from REGEXP_REPLACE;
drop view REGEXP_REPLACE;


rename table REGEXP_LIKE as REGEXP_REPLACE;
alter table REGEXP_REPLACE change REGEXP_LIKE REGEXP_REPLACE integer;
create view REGEXP_SUBSTR as select REGEXP_REPLACE from REGEXP_REPLACE where REGEXP_REPLACE is not null;
select * from REGEXP_SUBSTR;
drop view REGEXP_SUBSTR;

rename table REGEXP_REPLACE as REGEXP_SUBSTR;
alter table REGEXP_SUBSTR change REGEXP_REPLACE REGEXP_SUBSTR integer;
create view TIMEZONE as select REGEXP_SUBSTR from REGEXP_SUBSTR where REGEXP_SUBSTR is not null;
select * from TIMEZONE;
drop view TIMEZONE;

rename table REGEXP_SUBSTR as TIMEZONE;
alter table TIMEZONE change REGEXP_SUBSTR TIMEZONE integer;
create view AES as select TIMEZONE from TIMEZONE where TIMEZONE is not null;
select * from AES;
drop view AES;

drop table TIMEZONE;
