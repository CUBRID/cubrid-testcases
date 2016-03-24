
drop table if exists t1;

CREATE TABLE t1( a VARCHAR(10), b VARCHAR(10)) collate utf8_en_ci;
--test: fail. we expect it will be successful.
alter table t1 change a a_new VARCHAR(10);
--note: correct behavior
alter table t1 change b b_new VARCHAR(10) collate utf8_en_cs;
show full columns from t1;

drop table if exists t1;

CREATE TABLE t1( a CHAR(10), b CHAR(10)) collate utf8_en_ci;

alter table t1 change a a_new VARCHAR(10);

alter table t1 change b b_new VARCHAR(10) collate utf8_en_cs;

show full columns from t1;

drop table if exists t1;

CREATE TABLE t1( a CHAR(1000), b CHAR(1000)) collate utf8_en_ci;

alter table t1 change a a_new CHAR(1000);

alter table t1 change b b_new VARCHAR(1000) collate utf8_en_cs;

show full columns from t1;

drop table if exists t1;

CREATE TABLE t1( a CHAR(1000) unique, b CHAR(1000) unique ) collate utf8_en_ci;

alter table t1 change a a_new CHAR(1000);

alter table t1 change b b_new VARCHAR(1000) collate utf8_en_cs;

show full columns from t1;

drop table if exists t1;