/*
Test Case: rename trigger
Priority: 1
Reference case:
Author: Lily

Test Point:
rename trigger, then fire the trigger in other transaction.
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT, col VARCHAR(10));
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id,obj.col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO tt1 VALUES(1,'test');
C1: RENAME TRIGGER tt1_insert AS trg1;
C1: INSERT INTO tt1 VALUES(2,'make');
MC: wait until C1 ready; 
C2: drop trigger tt1_insert;
MC: sleep 1;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;

C2: INSERT INTO tt1 VALUES(3,'run');
C2: SELECT * FROM hi order by id;
C2: commit; 
MC: wait until C2 ready;
C1: SELECT * FROM tt1 order by id;
C1: SELECT * FROM hi order by id;
C1: commit;
MC: wait until C1 ready;

/* Test case 2 */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT, col VARCHAR(10));
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id,obj.col);
C1: commit work;
MC: wait until C1 ready;

C1: RENAME TRIGGER tt1_insert AS trg1;
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(4,'com');
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: INSERT INTO tt1 VALUES(5,'dev');
C2: SELECT * FROM hi order by id;
C2: commit;
C2: quit;
C1: quit;
