/*
Test Case: serial 
Priority: 1
Reference case:
Author: Lily

Test Point:
use the Pseudocolumns of serial.

NUM_CLIENTS = 2
C1: select s1.current_value,s1.next_value from tt1 where sleep(1);
C2: insert into tt1 values(s1.next_value);
C2: insert into tt1 values(s1.next_value);
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: INSERT INTO tt1 VALUES(1,'test'),(2,'do'),(3,'run');
C1: CREATE SERIAL s1;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT s1.CURRENT_VALUE,s1.NEXT_VALUE FROM (select sleep(3)) x, tt1 order by 1,2;

C2: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Park');
C2: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Museum');
MC: wait until C2 ready;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: SELECT * FROM tt1 ORDER BY id,2;
C1: commit;
C1: SELECT * FROM tt1 ORDER BY id,2;
MC: wait until C1 ready;

C2: SELECT s1.CURRENT_VALUE,s1.NEXT_VALUE;
MC: wait until C2 ready;

C1: DROP SERIAL s1;
MC: wait until C1 blocked;

C2: commit;
MC: wait until C1 ready;
C1: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;
