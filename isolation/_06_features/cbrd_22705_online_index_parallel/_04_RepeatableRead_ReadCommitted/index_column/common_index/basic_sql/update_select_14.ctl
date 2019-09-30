
MC: setup NUM_CLIENTS = 4;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;


C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10));
C1: insert into t1 values(1,'abc');insert into t1 values(2,'def');insert into t1 values(3,'ghijk');insert into t1 values(4,'lmn');insert into t1 values(5,'opq');insert into t1 values(6,'rs');
C1: create index idx on t1(id) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t1;
MC: wait until C1 ready;

C2: create index idx1 on t1(id desc,col desc) with online parallel 2;
MC: wait until C2 blocked;

C3: update t1 set col='aaa' where id=6;
MC: wait until C3 blocked;

C4: select * from t1 where id>0 and (select sleep(6))=0 order by id;
MC: wait until C4 blocked;

C1: rollback;
MC: wait until C2 unblocked;
MC: wait until C3 ready;
MC: wait until C4 ready;
C3: commit;
MC: wait until C3 ready;

C4: commit;
MC: wait until C4 ready;

C2: commit;
MC: wait until C2 ready;

C1: select * from t1 where id>0 order by id;
MC: wait until C1 ready;
C2: select * from t1 where id>0 order by id;
C2: commit;
MC: wait until C2 ready;
C1: select * from t1 where id>0 order by id;
MC: wait until C1 ready;
C2: select * from t1 where id>0 order by id;
MC: wait until C2 ready;

C2: commit;
C1: commit;
C1: quit;
C2: quit;
C3: quit;
C4: quit;
