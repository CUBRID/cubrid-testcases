/*
Priority: 1
Reference case:
Isolation Level: read committed/read committed
Author: Bobo

Test Plan: 
Test the scenario that the returned error information is correct.

Test Point:
1) unique violation
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS sbtest; 
C1: CREATE TABLE sbtest ( id INTEGER NOT NULL AUTO_INCREMENT, k  INTEGER DEFAULT 0 NOT NULL, c  CHAR(120) DEFAULT '' NOT NULL, pad CHAR(60) DEFAULT '' NOT NULL, PRIMARY KEY (id)) REUSE_OID;
C1: CREATE INDEX i_sbtest_k ON sbtest(k);
C1: INSERT INTO sbtest values(5018469,0,' ','qwery'); 
C1: INSERT INTO sbtest values(4982690,0,' ','qwery'); 
C1: INSERT INTO sbtest values(4958124,0,' ','qwery'); 
C1: INSERT INTO sbtest values(3232164,0,' ','qwery');
C1: INSERT INTO sbtest values(5005056,0,' ','qwery'); 
C1: INSERT INTO sbtest values(4990187,0,' ','qwery'); 
C1: INSERT INTO sbtest values(5176347,0,' ','qwery');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: UPDATE sbtest set k=k+1 where id=5018469;
MC: wait until C1 ready;
C2: UPDATE sbtest set k=k+1 where id=5018469;
MC: wait until C2 blocked;
C3: UPDATE sbtest set k=k+1 where id=5018469;
MC: wait until C3 blocked;
C1: DELETE from sbtest where id=5018469;
C1: INSERT INTO sbtest values(5018469,0,' ','aaaaaaaaaaffffffffffrrrrrrrrrreeeeeeeeeeyyyyyyyyyy');
C1: commit;
MC: wait until C2 ready;
MC: wait until C3 ready;
C2: DELETE from sbtest where id=5018469;	
MC: wait until C2 ready;
C3: DELETE from sbtest where id=5018469;
MC: wait until C3 blocked;
C2: INSERT INTO sbtest values(5018469,0,' ','aaaaaaaaaaffffffffffrrrrrrrrrreeeeeeeeeeyyyyyyyyyy');
C2: commit;
MC: wait until C2 ready;

C3: INSERT INTO sbtest values(5018469,0,' ','aaaaaaaaaaffffffffffrrrrrrrrrreeeeeeeeeeyyyyyyyyyy');
C3: commit;
MC: wait until C3 ready;
C1: select * from sbtest order by 1,2,3,4;
C1: commit;

C3: quit;
C2: quit;
C1: quit;
        
