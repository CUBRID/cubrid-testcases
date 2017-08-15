/*
Test Case: trigger fired in different transaction
Priority: 1
Reference case:
Author: Lily

Test Point:
when trigger is called, invalidate transaction is executed

NUM_CLIENTS = 2
C1: update tt1 to fire a deferred trigger to execute invalidate transaction; 
C2: fire the trigger too; 
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
C1: CREATE TRIGGER tt1_insert DEFERRED UPDATE ON tt1 IF obj.col=100 EXECUTE INVALIDATE TRANSACTION;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE tt1 SET col=100 WHERE id=1; 
MC: wait until C1 ready;
C2: UPDATE tt1 SET col=80 WHERE id=2;
C2: commit;
MC: wait until C2 ready;
C1: SELECT * FROM tt1 order by 1,2;
/* expect failed to commit */
C1: commit;

C1: SELECT * FROM tt1 order by 1,2;
C1: rollback;
MC: wait until C1 ready;
C2: SELECT * FROM tt1 ORDER BY id;
C2: quit;
C1: quit;
