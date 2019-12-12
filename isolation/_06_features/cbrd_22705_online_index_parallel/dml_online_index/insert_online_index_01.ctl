
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint primary key,col varchar(10));
C1: insert into t select rownum,rownum from db_root connect by level<=100;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(200,'a');
MC: wait until C1 ready;
C2: create index idx1 on t(id desc,col desc) with online parallel 2;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: show indexes from t;
C2: commit;
MC: wait until C2 ready;
C1: select * from t where id >50 and col='a';
C1: commit work;
MC: wait until C1 ready;
C2: commit;

C2: quit;
C1: quit;

