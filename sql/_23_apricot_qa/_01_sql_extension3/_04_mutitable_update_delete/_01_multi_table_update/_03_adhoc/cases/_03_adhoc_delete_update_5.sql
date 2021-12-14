--+ holdcas on;
drop table if exists t1,t2;
CREATE TABLE t1 (i INT);
INSERT INTO t1 VALUES (1), (1), (1);
CREATE TABLE t2 (i INT);
INSERT INTO t2 VALUES (2), (2), (2);
UPDATE t1  inner join t2 on t1.i<t2.i SET t1.i= (SELECT MAX(i) FROM t2) +  (SELECT MAX(i) FROM t1) where rownum< 1;
drop table t1,t2;






drop table if exists t1,t2,t3;
CREATE TABLE t1 (i INT,j varchar(10));
CREATE TABLE t2 (i INT,j varchar(11));
INSERT INTO t1 VALUES (1,2);
INSERT INTO t2 VALUES (1,2);
CREATE TABLE t3  (
SELECT * FROM t1
UNION
SELECT * FROM t2);
drop table t1,t2,t3;






drop table if exists `report_table`,`report_column`;
CREATE TABLE `report_table` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` clob,
  `alias` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ;
CREATE TABLE `report_column` (
  `REPORT_COLUMN_ID` bigint NOT NULL AUTO_INCREMENT,
  `REPORT_ID` int NOT NULL,
  `COLUMN_NAME` varchar(3000) NOT NULL,
  `DISPLAY_NAME` varchar(50) NOT NULL,
  `ALIAS` varchar(255) DEFAULT NULL,
  `report_table_id` bigint NOT NULL,
  PRIMARY KEY (`REPORT_COLUMN_ID`)
)
insert into report_column select null,rownum,rownum,rownum,rownum,rownum from db_class limit 46;
update report_column rc set rc.report_table_id = coalesce((select id from report_table rt where left(rc.column_name, length(rt.alias)) = rt.alias), 0);
drop table `report_table`,`report_column`;







drop table if exists linkedTable,testTable;
CREATE TABLE linkedTable (testTableId INT) ;
CREATE TABLE testTable (id INT, da varchar(50), timestamp1 TIMESTAMP  ) ;
INSERT INTO linkedTable (testTableId)   VALUES (1);
INSERT INTO testTable   (id,da)       VALUES (1,'original data');
select * from linkedTable;
select * from testTable;
UPDATE linkedTable JOIN testTable ON testTableId=id 
SET da='original data' WHERE id=1;
select * from linkedTable;
select * from testTable;
drop table  linkedTable,testTable;








drop table if exists `test`,`test2`,test3;
CREATE TABLE `test` (
  `test_id` int(11) NOT NULL auto_increment   PRIMARY KEY,
  `parent_test_id` int(11) default NULL,
  `test_name` varchar(45) NOT NULL UNIQUE,

  CONSTRAINT `parent_test_test` FOREIGN KEY (`test_id`) REFERENCES `test` (`test_id`)
) 
insert into `test` (test_name) values ('test');
insert into `test` (test_name) values ('test1');
insert into `test` (test_name) values ('test2');
CREATE TABLE `test2` (
  `test_id` int(11) NOT NULL auto_increment   PRIMARY KEY,
  `parent_test_id` int(11) default NULL,
  `test_name` varchar(45) NOT NULL UNIQUE,

  CONSTRAINT `parent_test_test` FOREIGN KEY (`test_id`) REFERENCES `test` (`test_id`)
) 
insert into `test2` (test_name) values ('test');
insert into `test2` (test_name) values ('test1');
insert into `test2` (test_name) values ('test2');
CREATE TABLE `test3` (
  `test_id` int(11) NOT NULL auto_increment   PRIMARY KEY,
  `parent_test_id` int(11) default NULL,
  `test_name` varchar(45) NOT NULL UNIQUE,
  CONSTRAINT `parent_test_test` FOREIGN KEY (`test_id`) REFERENCES `test` (`test_id`)
) 
insert into `test3` (test_name) values ('test');
insert into `test3` (test_name) values ('test1');
insert into `test3` (test_name) values ('test2');
update test inner join test2 on test.test_id=test2.test_id set test.parent_test_id=null;
update test left join test2 on test.test_id=test2.test_id set test.parent_test_id=null;
update test left outer join test2 on test.test_id=test2.test_id set test.parent_test_id=null;
update test left outer join test2 on test.test_id=test2.test_id right outer join test3 on test.test_id=test3.test_id set test.parent_test_id=null,test3.parent_test_id=null,test2.parent_test_id=null;
update test left outer join test2 on test.test_id=test2.test_id set test.parent_test_id=null;
drop table test3,`test2`,`test`;
commit;
--+ holdcas off;
