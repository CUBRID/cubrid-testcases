set system parameters 'create_table_reuseoid=no';
-- bug CBRD-21304
drop table if exists t;

drop view if exists v;

CREATE TABLE t (a STRING DEFAULT to_char(CURRENT_DATETIME,'HH:MI:SS.FF AM MM/DD/YYYY') );

create view v as select * from t;

insert into v  values ('TEST') on duplicate key update a = default;

insert into v  values ('TEST') on duplicate key update a = default;

select * from v;

drop view v;

drop table t;


drop table if exists t1;

drop view if exists v1;

CREATE TABLE t1 (a STRING DEFAULT to_char(CURRENT_DATETIME,'HH:MI:SS.FF AM MM/DD/YYYY') unique);

create view v1 as select * from t1;

insert into v1 values ('TEST') on duplicate key update a = default;

insert into v1 values ('TEST') on duplicate key update a = default;

select if(a='TEST','nok','ok') from v1;

drop view v1;

drop table t1;



-- bug CBRD-21307
drop table if exists t3;

drop view if exists v3;

create table t3(s1 varchar default to_char(sysdate,'YYYY-MM-DD'),s2 varchar);

insert into t3 set s2=s1+1;

insert into t3 set s2=s1+'1';

create view v3 as select * from t3;

insert into v3 set s2=s1+'1';  

drop v3;

drop t3;

set system parameters 'create_table_reuseoid=yes';
