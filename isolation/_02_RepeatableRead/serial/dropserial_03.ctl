/*
Test Case: drop serial 
Priority: 1
Reference case:
Author: Lily

Test Point:
drop serial, then use the serial in other transaction.

NUM_CLIENTS = 2
C1: insert into tt1 values(s1.next_value);
C2: insert into tt1 values(s1.next_value);
C1: rollback;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit work;
/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE SERIAL s1;
C1: commit work;

/* test case */
C1: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Park');
C1: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Museum');
C1: DROP SERIAL s1;
MC: wait until C1 ready;
C2: CREATE SERIAL s1 start with 100;
MC: wait until C2 blocked;
C1: SELECT * FROM tt1 ORDER BY id;
C1: commit;
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Square');
C2: SELECT * FROM tt1 ORDER BY id;
C2: commit work;
C2: SELECT * FROM tt1 ORDER BY id;
MC: wait until C2 ready;
C1: SELECT * FROM tt1 ORDER BY id;
C1: DROP SERIAL s1;
C2: commit;
C1: commit;
C2: quit;
C1: quit;
