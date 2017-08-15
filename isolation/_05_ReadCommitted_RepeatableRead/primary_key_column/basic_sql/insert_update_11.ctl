/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Update: X_LOCK acquired on current instance
use index in where clause

NUM_CLIENTS = 2
C2: select snapshot(1,2,7)
C1: update x=x+1 and commit
C1: commit, (1,2,7) -> (2,3,8)
C2: insert 7, ready, confict with old update value
--maybe violate repeatable read snapshot which is 1,2,7
C2: select again, result (2,3,8,7) which is different from snapshot (1,2,7)
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'a');
C1: insert into t values(2,'b');
C1: insert into t values(7,'c');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set id=id+1 where id between 1 and 10;
C1: commit;
/* expect 1->2,2->3,7->8 */
C1: select * from t order by 1; 

/* expect 1,2,7 */
C2: select * from t where id>0 order by id;
C2: insert into t values(7,'abc');
MC: wait until C2 ready;

/* expect 1,2,(7,abc) */
C2: select * from t order by 1;
C2: commit;          

/* expect 2,3,8,(7,abc) */
C2: select * from t order by 1; 
C2: commit;

C1: commit;
C2: quit;
C1: quit;

