/*
Test Case: insert & update
Priority: 2 
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_update_10.ctl
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Update: X_LOCK acquired on current instance
insert use primary key index, and update do not use index

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: insert into t values(1,'a');
C1: insert into t values(2,'b');
C1: insert into t values(7,'c');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(4,'abc');
MC: wait until C1 ready;
C2: update t set id=4 where col='c'; 
MC: wait until C2 blocked;
/* expect (1,'a') (2,'b') (7,'c') (4,'abc')*/
C1: select * from t order by 1; 
C1: commit work;
MC: wait until C2 ready;
/* expect (1,'a') (2,'b') (7,'c') */
C1: select * from t order by 1; 
MC: wait until C1 ready;
C2: commit;          
/* expect (1,'a') (2,'b') (7,'c') (4,'abc')*/
C2: select * from t order by 1; 
C2: commit;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;

