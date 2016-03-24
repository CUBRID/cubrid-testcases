/*
Test Case: serial 
Priority: 1
Reference case:
Author: Lily

Test Point:
use the functions of serial.

NUM_CLIENTS = 2
C1: select SERIAL_NEXT_VALUE(s1,10);
C2: select SERIAL_NEXT_VALUE(s1,10);
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: INSERT INTO tt1 VALUES(1,'test'),(2,'do'),(3,'run');
C1: CREATE SERIAL s1 START WITH 101 INCREMENT BY 1 MAXVALUE 20000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT SERIAL_NEXT_VALUE(s1,10); 
MC: wait until C1 ready;
C2: SELECT SERIAL_NEXT_VALUE(s1,10);
C2: SELECT SERIAL_CURRENT_VALUE(s1),SERIAL_NEXT_VALUE(s1);
C2: DROP SERIAL s1;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: commit;
C2: quit;
C1: quit;
