/* 
Test Case: update
update duplicate data and commit while loading index with oline;
create unique index should be fail.
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: create table t1 (a int primary key auto_increment, b int, c char(250));
C1: insert into t1(b,c) values (1,'a'),(2,'b'),(3,'c'),(4,'d'),(5,'e'),(6,'f');
C1: COMMIT;
MC: wait until C1 ready;

/* transaction mix */

/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t1;
MC: wait until C1 ready;

C2: create unique index i on t1(b,c) with online parallel 3;
MC: wait until C2 blocked;

C3: update t1 set b=1,c='a';
MC: wait until C3 blocked;

C1: commit;
MC: wait until C2 unblocked;

/* C2 starts scan and will demote to IX. C3 and C4 will resume */

MC: wait until C3 ready;

/* C2 should be blocked to promote to SCH_M */
MC: wait until C2 blocked;

C3: commit;
MC: wait until C3 ready;

MC: wait until C2 ready;
C2: commit;

MC: wait until C2 ready;

/* verification */
C1: select sum(set{b}) into :s from t1 ignore index (i) where b > -999 order by 1;
C1: select sum(set{b}) into :i from t1 force index (i) where b > -999 order by 1;
C1: select if (:s = :i, 'OK', 'NOK');
C1: show index from t1;
C1: select * from t1 order by 1;
MC: wait until C1 ready;

/* exit */
C1: DROP table t1;
C1: commit;

C1: quit;
C2: quit;
C3: quit;
