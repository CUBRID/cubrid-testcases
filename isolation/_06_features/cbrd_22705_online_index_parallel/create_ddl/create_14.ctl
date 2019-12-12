MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;


/* preparation */
C1: DROP TABLE IF EXISTS t;
C1: create table t(i int primary key,j char(10),k int);
C1: insert into t select rownum,rownum,rownum from db_root connect by level<=5;
C1: COMMIT;
MC: wait until C1 ready;

/* transaction mix */

/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t;
MC: wait until C1 ready;

C2: create index a on t(k) with online parallel 2;
MC: wait until C2 blocked;

C3: alter table t add column m timestamp  on update current_timestamp;
MC: wait until C3 blocked;

C1: commit;
MC: wait until C2 unblocked;


/* C2 is ready */
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;


/* C3 is ready */
MC: wait until C3 ready;
C3: commit;
MC: wait until C3 ready;



/* verification */
C1: select sum(set{k}) into :s from t ignore index (a) where k > 0 order by 1;
C1: select sum(set{k}) into :i from t force index (a) where k > 0 order by 1;
C1: select if (:s = :i, 'OK', 'NOK');
C1: describe t;
C1: show index from t;
MC: wait until C1 ready;

/* exit */
C1: DROP table t;
C1: commit;

C1: quit;
C2: quit;
C3: quit;
