drop if exists t_colname;

create table t_colname (
AES int,
ARIA int,
BENCHMARK int,
EMPTY int,
ENCRYPT int,
ERROR int,
NESTED int,
ONLINE int,
ORDINALITY int,
PARALLEL int,
REGEXP_COUNT int,
REGEXP_INSTR int,
REGEXP_LIKE int,
REGEXP_REPLACE int,
REGEXP_SUBSTR int,
TIMEZONE int
);

create index AES               on t_colname (AES);                
create index ARIA              on t_colname (ARIA);
create index BENCHMARK         on t_colname (BENCHMARK);
create index EMPTY             on t_colname (EMPTY);
create index ENCRYPT           on t_colname (ENCRYPT);
create index ERROR             on t_colname (ERROR);
create index NESTED            on t_colname (NESTED);
create index ONLINE            on t_colname (ONLINE);
create index ORDINALITY        on t_colname (ORDINALITY);
create index PARALLEL          on t_colname (PARALLEL);
create index REGEXP_COUNT      on t_colname (REGEXP_COUNT);
create index REGEXP_INSTR      on t_colname (REGEXP_INSTR);
create index REGEXP_LIKE       on t_colname (REGEXP_LIKE);
create index REGEXP_REPLACE    on t_colname (REGEXP_REPLACE);
create index REGEXP_SUBSTR     on t_colname (REGEXP_SUBSTR);
create index TIMEZONE          on t_colname (TIMEZONE);	

insert into t_colname values (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 ,14, 15, 16);
select * from t_colname;
select AES, ARIA, BENCHMARK, EMPTY, ENCRYPT, ERROR, NESTED, ONLINE, ORDINALITY, PARALLEL, 
REGEXP_COUNT, REGEXP_INSTR, REGEXP_LIKE, REGEXP_REPLACE, REGEXP_SUBSTR, TIMEZONE
from t_colname;


create table AES (AES int);  
create index AES on AES (AES); 
insert into AES select AES from t_colname; 
select AES from AES; 
drop table AES;

create table ARIA (ARIA int);  
create index ARIA on ARIA (ARIA); 
insert into ARIA select ARIA from t_colname; 
select ARIA from ARIA; 
drop table ARIA;

create table BENCHMARK (BENCHMARK int);  
create index BENCHMARK on BENCHMARK (BENCHMARK);
insert into BENCHMARK select BENCHMARK from t_colname; 
select BENCHMARK from BENCHMARK; 
drop table BENCHMARK;

create table EMPTY (EMPTY int);  
create index EMPTY on EMPTY (EMPTY);
insert into EMPTY select EMPTY from t_colname; 
select EMPTY from EMPTY; 
drop table EMPTY;

create table ENCRYPT (ENCRYPT int);  
create index ENCRYPT on ENCRYPT (ENCRYPT);
insert into ENCRYPT select ENCRYPT from t_colname; 
select ENCRYPT from ENCRYPT; 
drop table ENCRYPT;

create table ERROR  (ERROR int);  
create index ERROR on ERROR (ERROR);
insert into ERROR select ERROR from t_colname; 
select ERROR from ERROR; 
drop table ERROR;

create table NESTED  (NESTED int);  
create index NESTED on NESTED (NESTED);
insert into NESTED select NESTED from t_colname; 
select NESTED from NESTED; 
drop table NESTED;

create table ONLINE  (ONLINE int);  
create index ONLINE on ONLINE (ONLINE);
insert into ONLINE select ONLINE from t_colname; 
select ONLINE from ONLINE; 
drop table ONLINE;

create table ORDINALITY  (ORDINALITY int);  
create index ORDINALITY on ORDINALITY (ORDINALITY);
insert into ORDINALITY select ORDINALITY from t_colname; 
select ORDINALITY from ORDINALITY; 
drop table ORDINALITY;

create table PARALLEL  (PARALLEL int);  
create index PARALLEL on PARALLEL (PARALLEL);
insert into PARALLEL select PARALLEL from t_colname; 
select PARALLEL from PARALLEL;
drop table PARALLEL;

create table REGEXP_COUNT (REGEXP_COUNT int);  
create index REGEXP_COUNT on REGEXP_COUNT (REGEXP_COUNT);
insert into REGEXP_COUNT select REGEXP_COUNT from t_colname; 
select REGEXP_COUNT from REGEXP_COUNT; 
drop table REGEXP_COUNT;

create table REGEXP_INSTR (REGEXP_INSTR int);  
create index REGEXP_INSTR on REGEXP_INSTR (REGEXP_INSTR);
insert into REGEXP_INSTR select REGEXP_INSTR from t_colname; 
select REGEXP_INSTR from REGEXP_INSTR; 
drop table REGEXP_INSTR;

create table REGEXP_LIKE (REGEXP_LIKE int);  
create index REGEXP_LIKE on REGEXP_LIKE (REGEXP_LIKE);
insert into REGEXP_LIKE select REGEXP_LIKE from t_colname; 
select REGEXP_LIKE from REGEXP_LIKE; 
drop table REGEXP_LIKE;

create table REGEXP_REPLACE (REGEXP_REPLACE int);  
create index REGEXP_REPLACE on REGEXP_REPLACE (REGEXP_REPLACE);
insert into REGEXP_REPLACE select REGEXP_REPLACE from t_colname; 
select REGEXP_REPLACE from REGEXP_REPLACE; 
drop table REGEXP_REPLACE;

create table REGEXP_SUBSTR (REGEXP_SUBSTR int);  
create index REGEXP_SUBSTR on REGEXP_SUBSTR (REGEXP_SUBSTR);
insert into REGEXP_SUBSTR select REGEXP_SUBSTR from t_colname; 
select REGEXP_SUBSTR from REGEXP_SUBSTR; 
drop table REGEXP_SUBSTR;

create table TIMEZONE (TIMEZONE int);  
create index TIMEZONE on TIMEZONE (TIMEZONE);
insert into TIMEZONE select TIMEZONE from t_colname; 
select TIMEZONE from TIMEZONE; 
drop table TIMEZONE;

drop table t_colname;
