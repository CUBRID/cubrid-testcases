/*
Test Case: trigger fired in different transaction
Priority: 1
Reference case:
Author: Lily

Test Point:
when trigger is called, reject is executed

NUM_CLIENTS = 2
C1: update tt1 to fire a deferred trigger to execute reject; 
C2: update tt1, too; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE tt1( id INT, col INT);
C1: INSERT INTO tt1 VALUES(1,60),(2,90);
C1: CREATE TRIGGER tt1_insert BEFORE UPDATE ON tt1 IF new.col=100 EXECUTE REJECT;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE tt1 SET col=100 WHERE id=2; 
MC: wait until C1 ready;
C2: UPDATE tt1 SET col=80 WHERE id=1;
C2: commit;
MC: wait until C2 ready;

C1: SELECT * FROM tt1 order by 1,2;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM tt1 ORDER BY id;
C2: quit;
C1: quit;
