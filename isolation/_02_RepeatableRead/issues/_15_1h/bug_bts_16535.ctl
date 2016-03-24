/*
Test Case: related to CUBRIDSUS-16535 ( Investigate reevaluation when dealing with referenced tables )
Priority: 1
Reference case:
Author: Bobo
*/
MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/*test point */
C1: CREATE table t1(a int);
C1: CREATE TABLE t2(a int, obj t1);
C1: INSERT INTO t1 VALUES (0);
C1: INSERT INTO t2 VALUES (0, NULL);
C1: UPDATE t2 SET obj = (SELECT t1 FROM t1 WHERE t1.a = t2.a);
C1: commit;
MC: wait until C1 ready;

C1: UPDATE t2 SET a=1 WHERE a=0;
C1: UPDATE t1 SET a=1 WHERE a=0;
MC: wait until C1 ready;
C2: UPDATE t2 SET a=2 WHERE obj.a=0; --here the T2 blocks waiting T1 to finish.
MC: wait until C2 blocked;
C1: commit; -- here t2 unblocks
MC: wait until C2 ready;
C2: SELECT a FROM t2;
MC: wait until C2 ready;
C2: commit;
C2: SELECT a FROM t2;
MC: wait until C2 ready;

C1: quit;
C2: quit;

