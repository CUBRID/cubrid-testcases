/*
Test case is from cubrid-testcases-private/manually/shell/1hour/bug_bts_5221/cases .
*/

/* preparation */
MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C1: drop table if exists t1;
C1: create table t1 (id1 int unique);
C1: insert into t1 values (1), (4), (8);
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: delete from t1 where id1 =4;
MC: wait until C1 ready;

C2: select * from t1 order by 1;
MC: wait until C2 ready;

C1: rollback;
MC: wait until C1 ready;

C2: select * from t1 order by 1;
MC: wait until C2 ready;

C1: delete from t1;
MC: wait until C1 ready;

C2: select * from t1 order by 1;
MC: wait until C2 ready;

C1: quit;
C2: quit;
