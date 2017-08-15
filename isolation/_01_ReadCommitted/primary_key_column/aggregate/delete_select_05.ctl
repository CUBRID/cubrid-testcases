/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_select_05.ctl
Author: Lily

Test Point:
simple group_concat, there are unvacuumed data, and uncommitted delete at the same time
C1 delete begin
                      C2 select group_concat() begin
                      C2 commit
C1 commit

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id=3;
C2: SELECT id/3, GROUP_CONCAT(name ORDER BY name SEPARATOR ':') FROM tb1 GROUP BY id/3; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id BIGINT PRIMARY KEY,name VARCHAR(20),hire_date DATE,sex ENUM('F','M'));
C1: INSERT INTO tb1 VALUES(1,'Jonh','2001-1-26','M');
C1: INSERT INTO tb1 VALUES(2,'Lucy','2002-4-12','F');
C1: INSERT INTO tb1 VALUES(3,'Tom','2002-2-18','M');
C1: INSERT INTO tb1 VALUES(4,'Mike','2001-9-26','F');
C1: INSERT INTO tb1 VALUES(5,'Jonh','2003-5-5','M');
C1: INSERT INTO tb1 VALUES(6,'Susan','2003-8-13','F');
C1: commit;

/* test case */
C1: DELETE FROM tb1 WHERE id=3;
MC: wait until C1 ready;
C2: SELECT id/3, GROUP_CONCAT(name ORDER BY name SEPARATOR ':') FROM tb1 GROUP BY id/3;
C2: commit work;
C2: SELECT id/3, GROUP_CONCAT(name ORDER BY name SEPARATOR ':') FROM tb1 GROUP BY id/3;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: SELECT id/3, GROUP_CONCAT(name ORDER BY name SEPARATOR ':') FROM tb1 GROUP BY id/3;
C2: commit work;

C2: quit;
C1: quit;
