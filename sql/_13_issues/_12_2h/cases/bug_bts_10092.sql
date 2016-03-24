drop table if exists t1;

CREATE TABLE t1( a int, b VARCHAR(10)) collate utf8_en_cs;
alter table t1 change a a_new VARCHAR(10);
--test: to check a_new's collation. It's wrong.
show full columns from t1;

drop table if exists t1;

CREATE TABLE t1( a bigint, b CHAR(1000)) collate utf8_en_cs;

alter table t1 change a a_new VARCHAR(10);

show full columns from t1;

drop table if exists t1;

CREATE TABLE t1( a double, b CHAR(1000)) collate utf8_en_cs;

alter table t1 change a a_new VARCHAR(10);

show full columns from t1;

drop table if exists t1;

CREATE TABLE t1( a numeric, b varCHAR(1000)) collate utf8_en_cs;

alter table t1 change a a_new VARCHAR(10);

show full columns from t1;

drop table if exists t1;

CREATE TABLE t1( a varCHAR(65535), b varCHAR(65535)) collate utf8_en_cs;

alter table t1 change a a_new VARCHAR(65535);

show full columns from t1;

drop table if exists t1;



