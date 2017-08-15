/*
Test Case: update & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/partition_table/range/with_index/primary_key/update_delete_02.ctl
Author: Rong Xu

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) 

Test Point:
C1 update, C2 delete, the affected rows are not overlapped

NUM_CLIENTS = 2
C1: UPDATE t1 SET col = 'abcd' WHERE id >= 5;
C2: DELETE FROM t1 WHERE id <= 2;  --expected no block
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: create table t1(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: INSERT INTO t1 VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl'),(5,'mno'),(6,'pqr'),(7,'abc');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'abcd' WHERE id >= 5;
MC: wait until C1 ready;

C2: DELETE FROM t1 WHERE id <= 2;
/* expect: no transactions need to wait */
MC: wait until C2 ready;

/* expect: C1 select - id = 5,6,7 are updated */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = 1,2 are deleted */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 5,6,7 are updated & id = 1,2 are deleted */
C2: select * from t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
