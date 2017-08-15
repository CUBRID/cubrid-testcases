/*
Test Case: drop trigger
Priority: 1
Reference case:
Author: Lily

Test Point:
drop trigger, then fire the trigger in other transaction.

NUM_CLIENTS = 2
C1: drop trigger trg1; 
C2: insert to fire the trigger; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT, col VARCHAR(20));
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id,obj.col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: INSERT INTO tt1 VALUES(1,'test');
C2: select * from hi order by 1,2;
C2: DROP TRIGGER tt1_insert;
C2: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id,obj.col||'from trigger');
C2: INSERT INTO tt1 VALUES(2,'make');
C2: select * from hi order by 1,2;
MC: wait until C2 ready; 
C1: INSERT INTO tt1 VALUES(3,'run'); 
MC: sleep 1;
MC: wait until C1 blocked;
C2: commit; 
MC: sleep 1;
MC: wait until C1 ready;
C1: INSERT INTO tt1 VALUES(4,'dev');
C1: SELECT * FROM hi order by 1,2;
C1: commit; 
C1: SELECT * FROM hi order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT, col VARCHAR(20));
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id,obj.col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO tt1 VALUES(1,'test');
C1: select * from hi order by 1,2;
C1: DROP TRIGGER tt1_insert;
C1: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id,obj.col||'from trigger');
C1: INSERT INTO tt1 VALUES(2,'make');
C1: select * from hi order by 1,2;
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(3,'run'); 
MC: sleep 1;
MC: wait until C2 blocked;
C1: commit;
MC: sleep 1;
MC: wait until C2 ready;
C2: INSERT INTO tt1 VALUES(4,'dev'); 
C2: commit;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by 1,2;
C1: commit work;
C1: SELECT * FROM hi order by 1,2;
C1: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;
