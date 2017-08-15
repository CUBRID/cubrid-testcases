MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed ;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed ;

/* preparation */
C1: DROP table IF EXISTS t;
C1: DROP view v;
C1: commit;
MC: wait until C1 ready;

C1: create table t (i int);
C1: create view v as select * from t;
C1: commit;

/* test */
C1: create or replace view v as select * from t;
C1: drop view v;
C1: rollback;
MC: wait until C1 ready;

C2: create view v as select * from t; /* crash at here */
C2: rollback;
MC: wait until C2 ready;

C1: quit;
C2: quit;
