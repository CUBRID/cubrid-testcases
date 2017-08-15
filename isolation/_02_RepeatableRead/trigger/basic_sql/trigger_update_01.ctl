/*
Test Case: update in trigger & insert
Priority: 1
Reference case:
Author: Lily

Test Point:
when trigger is called, update statement is executed
there is primary key on tables;

NUM_CLIENTS = 2
C1: insert into tt1 to fire a trigger to update a row in hi;
C2: insert different row into hi; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT PRIMARY KEY, col VARCHAR(10));
C1: INSERT INTO hi VALUES(1,'111');
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE UPDATE hi SET id=id+10 WHERE id = obj.id;
C1: commit work;

/* test case */
C1: INSERT INTO tt1 VALUES(1,'test');
MC: wait until C1 ready;
C2: INSERT INTO hi VALUES(2,'test');
C2: SELECT * FROM hi order by id;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by id;
C1: commit work;
MC: wait until C1 ready;

C2: commit work;
C2: SELECT * FROM hi order by id;
C2: commit work;
MC: wait until C2 ready;

/* test case */
C1: INSERT INTO tt1 VALUES(2,'call');
MC: wait until C1 ready;
C2: INSERT INTO hi VALUES(12,'test');
MC: wait until C2 blocked;
C1: select * from hi order by id;
C1: commit;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by id;
MC: wait until C1 ready;
C2: commit work;
C2: SELECT * FROM hi order by id;
C2: commit work;

C1: commit;
C2: quit;
C1: quit;
