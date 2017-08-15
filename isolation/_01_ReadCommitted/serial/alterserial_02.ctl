/*
Test Case: alter serial 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/serial/alterserial_01.ctl
Author: Lily

Test Point:
alter serial's increment by, then use the serial in other transaction.

NUM_CLIENTS = 2
C1: insert into tt1 values(s1.next_value);
C2: insert into tt1 values(s1.next_value);
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE SERIAL s1;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Park');
C1: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Museum');
C1: ALTER SERIAL s1 INCREMENT BY 2;
C1: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Cinema'); 
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Square');
C2: SELECT * FROM tt1 ORDER BY id;
MC: wait until C2 ready;
C1: commit work;
C1: SELECT * FROM tt1 ORDER BY id;
MC: wait until C1 ready;
C2: SELECT * FROM tt1 ORDER BY id;
MC: wait until C2 ready;
C1: DROP SERIAL s1;
C1: commit;
C2: quit;
C1: quit;
