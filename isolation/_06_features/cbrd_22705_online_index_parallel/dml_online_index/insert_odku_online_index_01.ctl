
MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint primary key,col varchar(10));
C1: insert into t select rownum,rownum||'a' from db_root connect by level<=10;
C1: commit;
MC: wait until C1 ready;

/* test case */
/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t;
MC: wait until C1 ready;

C2: create index idx1 on t(id desc,col desc) with online parallel 2;
MC: wait until C2 blocked;

C3: insert into t values (10,'10a') on duplicate key update id=id+1;
MC: wait until C3 blocked;

C4: update t set col='c' where id=5;
MC: wait until C4 blocked;

C1: commit;
MC: wait until C2 unblocked;

/* C2 starts scan and will demote to IX. C3 and C4 will resume */

MC: wait until C3 ready;
MC: wait until C4 ready;

/* C2 should be blocked to promote to SCH_M */
MC: wait until C2 blocked;

C3: commit;
MC: wait until C3 ready;

C4: commit;
MC: wait until C4 ready;


C2: commit;
MC: wait until C2 ready;

C1: show indexes from t;
C1: select * from t where id>5 and col >'5' order by 1 desc,2 desc;
C1: commit work;

C4: quit;
C3: quit:
C2: quit;
C1: quit;

