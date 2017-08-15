/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/filter_index/basic_sql/delete_select_01.ctl 
Author: Lily

Test Point:
The only visible uncommitted data are the effects of current transaction updates

NUM_CLIENTS = 1 
C1: delete from tb1;
C1: select * from tb1 order by 1,2;
C1: rollback; 
C1: select * from tb1 order by 1,2;
*/

MC: setup NUM_CLIENTS = 1;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id BIGINT NOT NULL,title VARCHAR(128),postDate TIMESTAMP NOT NULL,deleted SMALLINT DEFAULT 0);
C1: INSERT INTO tb1 VALUES(1,'tips','2010-01-06',1),(2,'market','2010-03-06',0),(3,'sales','2009-04-06',1),(4,'net','2010-12-06',1),(5,'web','2010-07-06',0);
C1: INSERT INTO tb1 VALUES(6,'help','2009-12-06',0),(7,'guide','2009-11-06',1),(8,'read','2010-3-06',1),(9,'SQL','2010-07-06',0),(10,'Java','2010-08-06',1);
C1: CREATE INDEX idx ON tb1(postDate) WHERE postDate>'2010-01-01';
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 USE INDEX (idx) WHERE postDate>'2010-04-01' AND postDate<'2010-08-01';
C1: DELETE FROM tb1 USE INDEX (idx) WHERE postDate='2010-12-06';
C1: DELETE FROM tb1 USE INDEX (idx) WHERE postDate='2010-04-06';
C1: SELECT * FROM tb1 USE INDEX (idx) WHERE postDate>'2010-01-01' order by 1,2,3,4;
C1: rollback;
C1: SELECT * FROM tb1 USE INDEX (idx) WHERE postDate>'2010-01-01' order by 1,2,3,4;
C1: commit work;

C1: quit;

