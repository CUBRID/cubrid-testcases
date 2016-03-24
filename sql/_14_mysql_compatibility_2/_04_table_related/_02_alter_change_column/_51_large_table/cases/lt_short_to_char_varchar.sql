---- ALTER TABLE ...  CHANGE COLUMN  , type change : SHORT to CHAR
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed



-------------- SHORT 1 : to VARCHAR , enough precision
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767),(100),(5060),(2020),(20410),(-100),(-5060),(-2020),(-20410);
insert into t1 select cast ((3*sh1)%32768 as short) from t1;
insert into t1 select sh1/4 from t1;
insert into t1 select cast ((5*sh1)%32768 as short) from t1;
insert into t1 select sh1/6 from t1;
insert into t1 select cast ((7*sh1)%32768 as short) from t1;
insert into t1 select sh1/8 from t1;
insert into t1 select cast ((9*sh1)%32768 as short) from t1;
insert into t1 select sh1/10 from t1;
insert into t1 select cast ((11*sh1)%32768 as short) from t1;
insert into t1 select sh1/12 from t1;
insert into t1 select cast ((13*sh1)%32768 as short) from t1;
insert into t1 select sh1/14 from t1;


select count(*),min(sh1),max(sh1) from t1;
select length(to_char(sh1)),count(sh1) from t1 group by length(to_char(sh1));

show columns in t1;


alter table t1 change sh1 s1 varchar(16);
-- should be ok 

insert into t1 values ('1234567');

select count(*),min(s1),max(s1) from t1;

select length(s1),count(s1) from t1 group by length(s1);

show columns in t1;

drop table t1;


-------------- SHORT 1 : to CHAR , enough precision
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767),(100),(5060),(2020),(20410),(-100),(-5060),(-2020),(-20410);
insert into t1 select cast ((3*sh1)%32768 as short) from t1;
insert into t1 select sh1/4 from t1;
insert into t1 select cast ((5*sh1)%32768 as short) from t1;
insert into t1 select sh1/6 from t1;
insert into t1 select cast ((7*sh1)%32768 as short) from t1;
insert into t1 select sh1/8 from t1;
insert into t1 select cast ((9*sh1)%32768 as short) from t1;
insert into t1 select sh1/10 from t1;
insert into t1 select cast ((11*sh1)%32768 as short) from t1;
insert into t1 select sh1/12 from t1;
insert into t1 select cast ((13*sh1)%32768 as short) from t1;
insert into t1 select sh1/14 from t1;


select count(*),min(sh1),max(sh1) from t1;
show columns in t1;

alter table t1 change sh1 s1 char(160);

insert into t1 values ('abcdef');

select count(*),min(s1),max(s1) from t1;

show columns in t1;

drop table t1;

