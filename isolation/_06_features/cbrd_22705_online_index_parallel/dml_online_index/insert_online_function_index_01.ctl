
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint primary key,col1 varchar(10),col2 int);
C1: insert into t select rownum,rownum,rownum from db_root connect by level<=100;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: create index idx1 on t(id,upper(col1),col2 desc) with online parallel 2;
MC: wait until C1 ready;
C2: insert into t select rownum+100,'a'||rownum,rownum from db_root connect by level<=100;
MC: wait until C2 blocked;
C1: commit;
C1: update statistics on t;
C1: show indexes from t;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C1: update statistics on t;
C1: show indexes from t;
C1: select * from t where id >80 and upper(col1) >'A50' and col2> 90;
C1: commit work;

C2: quit;
C1: quit;

