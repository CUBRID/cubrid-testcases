/*
Issue Case: CUBRIDSUS-17597
Priority: 1
Reference case:
Isolation Levels: Repeatable Read
Author: Ray

Test Plan: 
Test if the invisible objects becomes visible after ALTER TABLE execution

Test Scenario:
C1 select, C2 insert/delete alter
C1 commit, C2 commit

Test Point:
1) C2 should not be blocked for C1 (locking)
2) C1 couldn't see the C2 changes since repeatable read
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1;
C1: drop table if exists t2;
C1: create table t1 (id1 int);
C1: create table t2 (id1 int);
C1: insert into t2 values (1);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case 1, VALID_INSID flag is overwritten by VALID_DELID */
C1: select * from t2;
MC: wait until C1 ready;
/* expect: C2 no need to wait for C1 */
C2: insert into t1 values (1);
C2: commit;
MC: wait until C2 ready;
C2: delete from t1;
C2: alter table t1 change column id1 id1 bigint;
C2: commit;
MC: wait until C2 ready;
/* expect: C1 should not see any changes of t1 */
C1: select * from t1;
MC: wait until C1 ready;
C1: commit;

/* preparation */
C1: drop table if exists t1;
C1: drop table if exists t2;
C1: create table t1 (id1 int);
C1: create table t2 (id1 int);
C1: insert into t2 values (1);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case 2, VALID_INSID flag is overwritten by VALID_INSID/VALID_DELID */
C1: select * from t2;
MC: wait until C1 ready;
/* expect: C2 no need to wait for C1 */
C2: insert into t1 values (1);
C2: commit;
MC: wait until C2 ready;
C2: update t1 set id1 = 2 where id1 = 1;
C2: alter table t1 change column id1 id1 bigint;
C2: commit;
MC: wait until C2 ready;
/* expect: C1 should not see any changes of t1 */
C1: select * from t1;
MC: wait until C1 ready;
C1: commit;

C1: quit;
C2: quit;
