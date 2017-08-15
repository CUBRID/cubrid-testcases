/*
Test Case: trigger fired in different transaction
Priority: 1
Reference case:
Author: Lily

Test Point:
when trigger is called, insert statement is executed

NUM_CLIENTS = 2
C1: insert into tt1 to fire a trigger to insert a row into hi; 
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
C1: CREATE TABLE hi( id INT, col VARCHAR(10));
C1: CREATE TABLE tt1( id INT primary key, col VARCHAR(10));
C1: CREATE TRIGGER tt1_insert before INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(new.id, new.col);
C1: CREATE TRIGGER tt1_update AFTER UPDATE ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id, 'update');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO tt1 VALUES(1,'test');
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(1,'hard');
MC: wait until C2 blocked;
C1: update tt1 set id=id+10,col='update' where id=1;
C1: INSERT INTO tt1 values(3,'dev') on duplicate key update id=5;
C1: INSERT INTO tt1 values(3,'play') on duplicate key update id=5;
MC: wait until C1 ready;
C1: commit work;
MC: wait until C2 ready;
C2: SELECT * FROM hi order by 1,2;
C2: commit work;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by 1,2;
C2: SELECT * FROM hi order by 1,2;

C2: quit;
C1: quit;
