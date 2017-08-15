/*
Test Case: serial 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/serial/serial_trigger_01.ctl
Author: Lily

Test Point:
use the serial in trigger.

NUM_CLIENTS = 2
C1: insert into tt1 to fire a trigger;
C1: select SERIAL_NEXT_VALUE(s1,10);
C2: insert into tt1 to fire a trigger;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT, col VARCHAR(10));
C1: CREATE SERIAL s1;
C1: CREATE TRIGGER trg1 BEFORE INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(s1.NEXT_VALUE,new.col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO tt1 VALUES(1,'Park');
C1: SELECT SERIAL_NEXT_VALUE(s1,10);
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(3,'Square');
C2: DROP SERIAL s1;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: CREATE SERIAL s1 start with 100;
C2: INSERT INTO tt1 VALUES(3,'Square');
MC: wait until C2 ready;
C1: INSERT INTO tt1 VALUES(9,'factory');
C2: commit;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM hi ORDER BY id;
MC: wait until C2 ready;
C1: SELECT * FROM hi ORDER BY id;
C1: DROP SERIAL s1;
C2: commit;
C1: commit;
C2: quit;
C1: quit;
