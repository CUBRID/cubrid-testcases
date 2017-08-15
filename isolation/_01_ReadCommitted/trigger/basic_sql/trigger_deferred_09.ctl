/*
Test Case: deferred trigger & update
Priority: 1
Reference case:
Author: Lily

Test Point:
when trigger is called, insert statement is executed

NUM_CLIENTS = 2
C1: update tt1 to fire a trigger to update a row from hi; 
C2: update different row from hi; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT PRIMARY KEY, col VARCHAR(20));
C1: INSERT INTO hi VALUES(1,'111'),(2,'222'),(3,'333');
C1: CREATE TABLE tt1( id INT, col INT);
C1: INSERT INTO tt1 VALUES(1,60),(2,60),(3,60);
C1: CREATE TRIGGER deferred_trg DEFERRED UPDATE ON tt1 IF obj.col=100 EXECUTE UPDATE hi SET col=NULL WHERE id=obj.id;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE tt1 SET col=100 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE hi SET col='manual' WHERE id=2;
/* because of defferred trigger */
MC: wait until C2 ready;
C1: select * from hi order by id;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM hi order by id;
C2: commit;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by id;
C2: quit;
C1: quit;
