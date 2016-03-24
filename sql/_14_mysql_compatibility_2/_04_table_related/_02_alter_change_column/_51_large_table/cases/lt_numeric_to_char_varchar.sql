---- ALTER TABLE ...  CHANGE COLUMN  , type change : SHORT to CHAR
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed



-------------- NUMERIC 1 : to VARCHAR , enough precision
create table t1 (n1 numeric(38,10));
insert into t1 values (100),(-100),(99999999999999999999.99999999),(-99999999999999999999.99999999),(0.010001001),(-0.010001001),(1.1),(-1.1),(100.2001),(-100.2001);
insert into t1 select 3*n1 from t1;
insert into t1 select n1/4 from t1;
insert into t1 select 5*n1 from t1;
insert into t1 select n1/6 from t1;
insert into t1 select 7*n1 from t1;
insert into t1 select n1/8 from t1;
insert into t1 select 9*n1 from t1;
insert into t1 select n1/10 from t1;
insert into t1 select 11*n1 from t1;
insert into t1 select n1/12 from t1;
insert into t1 select 13*n1 from t1;
insert into t1 select n1/14 from t1;

select count(*),min(n1),max(n1) from t1;
select length(to_char(n1)),count(n1) from t1 group by length(to_char(n1));

show columns in t1;


alter table t1 change n1 s1 varchar(50);

-- should be ok 
insert into t1 values ('12345678901234567890123456789012345678901234567890');

select count(*),min(s1),max(s1) from t1;

select length(s1),count(s1) from t1 group by length(s1);

show columns in t1;

drop table t1;


-------------- SHORT 1 : to CHAR , enough precision
create table t1 (n1 numeric(38,10));
insert into t1 values (100),(-100),(99999999999999999999.99999999),(-99999999999999999999.99999999),(0.010001001),(-0.010001001),(1.1),(-1.1),(100.2001),(-100.2001);
insert into t1 select 3*n1 from t1;
insert into t1 select n1/4 from t1;
insert into t1 select 5*n1 from t1;
insert into t1 select n1/6 from t1;
insert into t1 select 7*n1 from t1;
insert into t1 select n1/8 from t1;
insert into t1 select 9*n1 from t1;
insert into t1 select n1/10 from t1;
insert into t1 select 11*n1 from t1;
insert into t1 select n1/12 from t1;
insert into t1 select 13*n1 from t1;
insert into t1 select n1/14 from t1;


select count(*),min(n1),max(n1) from t1;

show columns in t1;


alter table t1 change n1 s1 char(500);

-- should be ok 
insert into t1 values ('12345678901234567890123456789012345678901234567890');

select count(*),min(s1),max(s1) from t1;

show columns in t1;

drop table t1;

