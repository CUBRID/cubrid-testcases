--03_if_not_exists_bug_from_web_001.sql

drop class if exists t12366;
create class t12366(a varchar(10), b int not null);
CREATE TABLE IF NOT EXISTS `dba`.`t12366` (
    `col` VARCHAR(16) NOT NULL
);
desc t12366;

drop class if exists t12366;
CREATE TABLE IF NOT EXISTS `public`.`t12366` (
    `col` VARCHAR(16) NOT NULL
);
desc public.t12366;


drop class if exists public.t12366;
CREATE TABLE IF NOT EXISTS `public`.`t12366` (
    `col` VARCHAR(16) NOT NULL
);
desc public.t12366;

drop class if exists public.t12366;
CREATE TABLE IF NOT EXISTS `public`.`public`.`t12366` (
    `col` VARCHAR(16) NOT NULL
);
desc public.public.t12366;

drop class if exists publics.t12366;
CREATE TABLE IF NOT EXISTS `publics`.`t12366` (
    `col` VARCHAR(16) NOT NULL
);
desc publics.t12366;

drop class if exists publics.t12366;
CREATE TABLE IF NOT EXISTS `public`.`public` (
    `col` VARCHAR(16) NOT NULL
);
desc public.public;
drop class if exists public.public;


drop class if exists "public"."select";
CREATE TABLE IF NOT EXISTS `public`.`select` (
    `col` VARCHAR(16) NOT NULL
);
desc select;
drop class if exists "public"."select";

DROP TABLE IF EXISTS backupfiles;
CREATE TABLE IF NOT EXISTS backupfiles (fileName VARCHAR(20), archiveId VARCHAR(500), checkSum VARCHAR(100), glacierVault VARCHAR(100), timeStamps date);
desc dba.backupfiles;
INSERT INTO backupfiles VALUES ('$archive_file_name', '$archiveID', '$CURRENTVAULT', '$checkSum', CURDATE());
select count(*) from backupfiles;
DROP TABLE IF EXISTS backupfiles;

DROP TABLE if exists t1;
CREATE TABLE t1 (id INT NOT NULL);
INSERT INTO t1 VALUES (1),(1);
CREATE TABLE IF NOT EXISTS t1; SELECT * FROM t1 order by 1;
DROP TABLE if exists t1;

DROP TABLE if exists t1,t2;
CREATE TABLE t1 (id INT NOT NULL);
INSERT INTO t1 VALUES (1),(1);
CREATE TABLE t2 AS (SELECT * FROM t1);

DROP TABLE if exists t1;
CREATE TABLE t1 (id INT NOT NULL);
INSERT INTO t1 VALUES (1),(1);
CREATE VIEW IF NOT EXISTS t1 SELECT * FROM t1 order by 1;
DROP TABLE if exists t1;

DROP TABLE if exists t1,t2;
CREATE TABLE t1 (id INT NOT NULL);
INSERT INTO t1 VALUES (1),(1);
create table t2 (i int);
create table if not exists t2 AS (select * from t1);
create table if not exists t2 AS (select * from t1);
create table if not exists t2 AS (select * from (select * from t1 union select * from t1 ) tt);

DROP TABLE if exists t1,t2;
CREATE TABLE t1 (id INT NOT NULL);
INSERT INTO t1 VALUES (1),(1);
create table t2 as (select * from t1);
DROP TABLE if exists t2;
create table t2 as (select * from t1);



DROP TABLE if exists t1,t2;
CREATE TABLE t1 (id INT NOT NULL);
INSERT INTO t1 VALUES (1),(1);
create table if not exists t2 AS (select * from (select * from t1 union select * from t1 ) tt);
desc t2;

DROP TABLE if exists t1,t2;
CREATE TABLE t1 (id INT NOT NULL);
INSERT INTO t1 VALUES (1),(1);
create table t2 as (select * from t1);
desc t2;
select * from t2 order by 1;

DROP TABLE if exists t1,t2;
CREATE TABLE t1 (id INT NOT NULL);
INSERT INTO t1 VALUES (1),(1);
create table t2 as (select * from t1);
desc t2;
select * from t2 order by 1;

DROP TABLE if exists t1,t2;
CREATE TABLE t1 (id INT NOT NULL);
INSERT INTO t1 VALUES (1),(1);
CREATE TABLE IF NOT EXISTS t2 AS SELECT * FROM t1;

DROP TABLE if exists t1,t2;

DROP TABLE if exists t1,t2;
CREATE TABLE t1 (id INT NOT NULL);
INSERT INTO t1 VALUES (1),(1);
CREATE TABLE IF NOT EXISTS t1; SELECT * FROM t1;

DROP TABLE if exists t1,t2;

DROP TABLE IF EXISTS ttt;
CREATE TABLE IF NOT EXISTS ttt AS SELECT 0 AS n;
CREATE TABLE IF NOT EXISTS ttt AS SELECT 0 AS n;
SELECT COUNT(*) FROM ttt;

DROP TABLE IF EXISTS ttt;

DROP TABLE IF EXISTS t;
CREATE TABLE t as (SELECT 1);
insert into t values(null);

DROP TABLE IF EXISTS t;

DROP t1;
CREATE VIEW t1 AS SELECT 1;
DROP t1;
CREATE VIEW t1 AS (SELECT 1);
DROP t1;
CREATE VIEW t1 AS (SELECT 1) as 1;
DROP t1;
CREATE VIEW t1 AS (SELECT 1 as 1);
DROP t1;
CREATE VIEW t1 AS (SELECT 1 as a);
DROP t1;
CREATE VIEW t1 AS (SELECT 1 as "1");

DROP t1;

DROP TABLE if exists t1,t2;
CREATE TABLE t1 (id INT NOT NULL);
INSERT INTO t1 VALUES (1),(1);
CREATE TEMPORARY TABLE IF NOT EXISTS t2 SELECT * FROM t1;

DROP TABLE if exists t1,t2;
drop `public`.`select`;
