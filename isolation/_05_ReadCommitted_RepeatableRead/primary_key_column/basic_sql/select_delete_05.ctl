/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/select_delete_01.ctl     
Author: Lily

Test Point:
changes committed after the transaction started are never seen

NUM_CLIENTS = 2
C1: SELECT * FROM tb1 WHERE sleep(1,col)=1 ORDER BY col;
C2: DELETE FROM tb1 WHERE id = 2;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc');
C1: INSERT INTO tb1 VALUES(2,'tell');
C1: INSERT INTO tb1 VALUES(3,'call');
C1: INSERT INTO tb1 VALUES(4,'ball');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT tb1.* FROM tb1 ORDER BY col;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id = 4;
C2: commit work;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 ORDER BY col;
C1: commit work;
C1: SELECT * FROM tb1 ORDER BY col;
C1: commit;
C2: quit;
C1: quit;
