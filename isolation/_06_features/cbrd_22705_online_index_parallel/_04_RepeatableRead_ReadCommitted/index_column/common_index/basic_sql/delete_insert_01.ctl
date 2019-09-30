
MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(id) with online parallel 3;
C1: insert into t values(3,'abc');
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */

C1: describe t;
MC: wait until C1 ready;

C2: create index idx1 on t(id desc,col desc) with online parallel 2;
MC: wait until C2 blocked;

C1: delete from t where id>0;
MC: wait until C1 ready;

C3: insert into t values(7,'abc');
MC: wait until C3 blocked;
C1: commit work;
C3: commit;
/* expected (7,abc) */
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;
C3: quit;

