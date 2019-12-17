/* 
Test Case: update
update and commit while loading index with oline;
create index should be success.
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS a_tbl;DROP TABLE IF EXISTS b_tbl;
C1: CREATE TABLE a_tbl(id INT PRIMARY KEY, charge DOUBLE);CREATE TABLE b_tbl(rate_id INT, rate DOUBLE);
C1: INSERT INTO a_tbl VALUES (1, 100.0), (2, 1000.0), (3, 10000.0);INSERT INTO b_tbl VALUES (1, 0.1), (2, 0.0), (3, 0.2), (3, 0.5);
C1: COMMIT;
MC: wait until C1 ready;

/* transaction mix */

/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe a_tbl;
MC: wait until C1 ready;

C2: create index i on a_tbl(id,charge) with online parallel 2;
MC: wait until C2 blocked;

C3: UPDATE a_tbl INNER JOIN b_tbl ON a_tbl.id=b_tbl.rate_id SET a_tbl.charge = a_tbl.charge * (1 + b_tbl.rate) WHERE a_tbl.charge > 900.0;
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
C1: select sum(set{id}) into :s from a_tbl ignore index (i) where id > -999 order by 1;
C1: select sum(set{id}) into :i from a_tbl force index (i) where id > -999 order by 1;
C1: select if (:s = :i, 'OK', 'NOK');
C1: select sum(set{charge}) into :s2 from a_tbl ignore index (i) where id > -999 order by 1;
C1: select sum(set{charge}) into :i2 from a_tbl force index (i) where id > -999 order by 1;
C1: select if (:s2 = :i2, 'OK', 'NOK');
C1: show index from a_tbl;
MC: wait until C1 ready;

/* exit */
C1: DROP table a_tbl;DROP table b_tbl;
C1: commit;

C1: quit;
C2: quit;
C3: quit;
