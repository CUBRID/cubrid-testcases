/*
Test Case: deferred trigger & insert
Priority: 1
Reference case:
Author: Lily

Test Point:
when trigger is called, insert statement is executed

NUM_CLIENTS = 2
C1: update tt1 to fire a trigger to insert a row into hi; 
C2: insert into hi; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT PRIMARY KEY, col VARCHAR(20));
C1: CREATE TABLE tt1( id INT, col INT);
C1: INSERT INTO tt1 VALUES(1,60);INSERT INTO tt1 VALUES(2,60);INSERT INTO tt1 VALUES(3,60);
C1: CREATE TRIGGER deferred_trg DEFERRED UPDATE ON tt1 IF obj.col=100 EXECUTE INSERT INTO hi(id,col) VALUES(obj.id, 'got full marks' );
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE tt1 SET col=100 WHERE id=2;
MC: wait until C1 ready;
C2: INSERT INTO hi VALUES(2,'manual');
MC: wait until C2 ready;
C1: commit;
MC: sleep 1;
MC: wait until C1 blocked;
C2: SELECT * FROM hi order by id;
C2: commit;
MC: wait until C1 ready;
C1: SELECT * FROM hi order by id;
C1: rollback;
C1: UPDATE tt1 SET col=100 WHERE id=3;
MC: wait until C1 ready;
C2: INSERT INTO hi VALUES(1,'test');
C2: SELECT * FROM hi order by id;
C2: commit;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by id;
C1: commit;
C1: SELECT * FROM hi order by id;
C1: commit;

C2: quit;
C1: quit;

