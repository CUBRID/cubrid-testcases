-- bug CBRD-21305

drop table if exists t; 

drop view if exists v;

-- It should be failed,the length of default values exceeds fields definition
CREATE TABLE t (a varchar(10) default to_char(CURRENT_DATETIME,'HH:MI:SS.FF AM MM/DD/YYYY') unique);

-- success
CREATE TABLE t (a varchar(100) default to_char(CURRENT_DATETIME,'HH:MI:SS.FF AM MM/DD/YYYY') unique);

create view v as select * from t;

insert into t(a)  values ('test1');

insert into t(a)  values ('test2');

select * from t order by 1;

insert into t  values ('test1') on duplicate key update a = 'hello1';

insert into v  values ('test2') on duplicate key update a = 'hello2';

select * from t order by 1;

drop v;

drop t;
