/*
Test Case: serial 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/serial/serial_trigger_07.ctl
Author: Lily

Test Point:
use the serial in deferred trigger.

NUM_CLIENTS = 2
C1: update tt1 to fire a trigger;
C1: select SERIAL_NEXT_VALUE(serial_name, number);
C2: update tt1 to fire a trigger;
C1: commit;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: CREATE TABLE tt1( id INT, col INT);
C1: INSERT INTO tt1 VALUES(1,60),(2,79),(3,80);
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT PRIMARY KEY, col VARCHAR(10));
C1: CREATE SERIAL s1;
C1: CREATE TRIGGER deferred_trg DEFERRED UPDATE ON tt1 IF obj.col=100 EXECUTE INSERT INTO hi VALUES(s1.NEXT_VALUE,'got full mark!');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE tt1 SET col=100 WHERE id=1;
C1: SELECT SERIAL_CURRENT_VALUE(s1),SERIAL_NEXT_VALUE(s1,3);
C1: UPDATE tt1 SET col=100 WHERE id=2;
MC: wait until C1 ready;
C2: UPDATE tt1 SET col=100 WHERE id=3;
C2: commit work;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: SELECT * FROM hi ORDER BY id;
C1: SELECT * FROM hi ORDER BY id;
C1: DROP SERIAL s1;
C1: commit;
C2: quit;
C1: quit;
