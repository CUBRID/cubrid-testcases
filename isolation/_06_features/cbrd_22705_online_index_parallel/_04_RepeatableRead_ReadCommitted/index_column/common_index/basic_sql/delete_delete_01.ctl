
MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int, col int);
C1: insert into t select rownum,rownum%100 from db_class a,db_class b,db_class c where rownum <= 500;
C1: create index idx_col on t(col) with online parallel 3;
C1: create index idx_id on t(id) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: describe t;
MC: wait until C1 ready;

C2: create index idx1 on t(id desc,col desc) with online parallel 2;
MC: wait until C2 blocked;

C1: delete from t where col=1 and  (select sleep(5)=0);
MC: wait until C1 ready;
C1: commit;

MC: wait until C2 ready;
C2: delete from t where id=1101; 
C2: commit work;
MC: wait until C2 ready;
MC: wait until C1 ready;

/* expected C2 delete 0 row */
C1: commit;
MC: wait until C1 ready;

/* expected 0 row selected */
C2: select * from t where id=1 and col>'0' using index idx1(+);
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

