drop table if exists t;
create table t(a int);
insert into t values (1), (2), (3);
prepare stmt from 'select max(?) from t'; execute stmt using 10;
prepare stmt from 'select max(?) over() from t'; execute stmt using 10;

drop table t;
deallocate prepare stmt;

create table t(a int);
insert into t values (1), (2), (3);
prepare stmt from 'select max(?) from t'; execute stmt using 10;
--QUERY1: below result is good.
select max(100) over() from t;
--test: below result should be same with QUERY1
prepare stmt from 'select max(?) over() from t'; execute stmt using 10;
prepare stmt from 'select min(?) over() from t'; execute stmt using 10;
prepare stmt from 'select min(?) over() from t'; execute stmt using 10;
prepare stmt from 'select avg(?) over() from t'; execute stmt using 10;
prepare stmt from 'select min(?+?) over() from t'; execute stmt using 10,10;
prepare stmt from 'select avg(?+?) over() from t'; execute stmt using 10,10;
drop table t;
deallocate prepare stmt;
