/*
Test Case: delete & delete
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
C1 delete p1, C2 delete p2,expected no block

NUM_CLIENTS = 2
C1: DELETE FROM t where id in(1,2); 
C2: DELETE FROM t where id in(5,6); -- expected ready
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t;
C1: create table t(id int,col varchar(10)) partition by list(id)(partition p1 values in (1,2,3,4,5),partition p2 values in (6,7,8,9,10));
C1: INSERT INTO t VALUES(1,'abc'),(2,'def'),(6,'ghi'),(10,'jkl');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t where id in(1,2); 
MC: wait until C1 ready;

C2: DELETE FROM t where id in(6,10);
MC: wait until C2 ready;

/* expect (6,'ghi'),(10,'jkl') */
C1: SELECT * FROM t order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* expect (1,'abc'),(2,'def') */
C2: SELECT * FROM t order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expect no value */
C2: SELECT * FROM t order by 1,2;
C2: commit;

C1: quit;
C2: quit;
