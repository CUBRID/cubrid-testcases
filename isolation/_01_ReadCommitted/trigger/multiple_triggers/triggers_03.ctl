/*
Test Case: trigger fired in different transaction
Priority: 1
Reference case:
Author: Lily

Test Point:
when trigger is called, update statement is executed

NUM_CLIENTS = 2
C1: insert into tt1 to fire a trigger to update a row into hi; 
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
C1: CREATE TABLE hi( id INT PRIMARY KEY, col VARCHAR(10));
C1: INSERT INTO hi VALUES(1,'111'),(2,'222');
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: INSERT INTO tt1 VALUES(1,'call'),(2,'test');
C1: CREATE TRIGGER tt1_insert BEFORE DELETE ON tt1 EXECUTE UPDATE hi SET col=NULL WHERE id=obj.id;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tt1 WHERE id=1; 
MC: wait until C1 ready;
C2: DELETE FROM tt1 WHERE id=2;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by 1,2;
MC: wait until C1 ready;
C2: SELECT * FROM hi order by 1,2;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: SELECT * FROM hi order by 1,2;
C2: commit work;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by 1,2;
MC: wait until C1 ready;
C2: SELECT * FROM hi order by 1,2;

C2: quit;
C1: quit;
