/*
Test Case: update & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/partition_table/range/with_index/primary_key/update_delete_03.ctl
Author: Rong Xu

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) 

Test Point:
C1 update, C2 delete, update and delete on different partition,the affected rows are not overlapped

NUM_CLIENTS = 2
C1: UPDATE t SET id = id+10 WHERE col='abc'; -- update to new value 11,20
C2: DELETE FROM t WHERE id >= 20;  -- 0 rows deleted, can not see C1's new value
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: INSERT INTO t VALUES(1,'abc');
C1: INSERT INTO t VALUES(10,'abc');
C1: INSERT INTO t VALUES(40,'ghi');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t SET id = id+10 WHERE col='abc';
MC: wait until C1 ready;

C2: DELETE FROM t WHERE id >= 20;
/* expect: no transactions need to wait */
MC: wait until C2 ready;

/* expect: C1 select - id = 11,20,40 are updated */
C1: SELECT * FROM t order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = 1,10 are deleted */
C2: SELECT * FROM t order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 11,20 */
C3: select * from t order by 1,2;
C3: commit;
MC: wait until C3 ready;

C1: select * from t order by 1,2;
C1: commit;

C1: quit;
C2: quit;
C3: quit;
