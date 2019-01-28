MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: create table t1 (b int, c char(2) default 'a');
C1: insert into t1(b,c) values (1,'a'),(2,'b'),(3,'c'),(4,'d'),(5,'e'),(6,'f');
C1: create unique index i on t1(b);
C1: COMMIT;
MC: wait until C1 ready;

/* transaction mix */
C2: select * from t1 force index (i) where b > -999 order by 1;
MC: wait until C2 ready;

C1: alter index i on t1 invisible;
MC: wait until C1 blocked;

C2: COMMIT;
MC: wait until C2 ready;

C1: select * from t1 force index (i) where b > -999 order by 1;
MC: wait until C2 ready;

C2: select * from t1 force index (i) where b > -999 order by 1;
MC: wait until C2 blocked;

C1: ROLLBACK;
MC: wait until C1 ready;

C2: show index from t1;
MC: wait until C2 ready;

C1: quit;
C2: quit;
