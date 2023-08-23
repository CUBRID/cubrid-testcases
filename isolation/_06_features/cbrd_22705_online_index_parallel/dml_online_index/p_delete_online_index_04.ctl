
MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint primary key,col char(5000)) PARTITION BY RANGE (id) (PARTITION before_600 VALUES LESS THAN (600),PARTITION before_1200 VALUES LESS THAN (1200));
C1: insert into t select rownum,rownum from db_root connect by level<=1000;
C1: update statistics on t;
C1: commit;
MC: wait until C1 ready;


/* test case */
/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t;
MC: wait until C1 ready;

C2: create unique index idx1 on t(col,id) with online parallel 2;
MC: wait until C2 blocked;

C3: delete from t where col>'5';
MC: wait until C3 blocked;

C1: commit;
MC: wait until C2 unblocked;
MC: wait until C3 ready;

C3: commit;
MC: wait until C3 ready;

C2: commit;
MC: wait until C2 ready;

C1: update statistics on t;
C1: show indexes from t;
C1: select id,trim(col) from t where col>'4' order by 1 desc limit 10;
C1: drop table t;
C1: commit work;

C2: quit;
C1: quit;
C3: quit;

