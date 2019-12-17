/*
Test Case: deferred trigger & delete
Priority: 1
Reference case:
Author: Lily

Test Point:
when trigger is called, insert statement is executed

NUM_CLIENTS = 2
C1: update tt1 to fire a trigger to delete a row from hi; 
*/
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT, col VARCHAR(20));
C1: INSERT INTO hi VALUES(1,'111'),(2,'222'),(3,'333');
C1: CREATE TABLE tt1( id INT, col INT);
C1: INSERT INTO tt1 VALUES(1,60),(2,60),(3,60);
C1: CREATE TRIGGER deferred_trg DEFERRED UPDATE ON tt1 IF obj.col=100 EXECUTE DELETE FROM hi WHERE id=obj.id;
C1: commit work;

/* same row - insert */
C1: UPDATE tt1 SET col=100 WHERE id=2;
MC: wait until C1 ready;
C2: INSERT INTO hi VALUES(2,'manual');
C2: SELECT * FROM hi order by id,col;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM hi order by id,col;
C2: commit;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by id,col;
C2: SELECT * FROM hi order by id,col;
C2: commit;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

/* same row - update */
C1: UPDATE tt1 SET col=100 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE hi SET col=NULL WHERE id=1;
C2: SELECT * FROM hi order by id,col;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 blocked;
C2: SELECT * FROM hi order by id,col;
C2: commit;
MC: wait until C1 ready;
C1: rollback;
C1: SELECT * FROM hi order by id,col;
MC: wait until C1 ready;
C2: SELECT * FROM hi order by id,col;

C2: commit;
C1: commit;
C2: quit;
C1: quit;
