/*
Test Case: insert in trigger & update
Priority: 1
Reference case:
Author: Lily

Test Point:
when trigger is called, insert statement is executed
there is primary key on table;

NUM_CLIENTS = 2
C1: start transaction;
C2: update a row from hi;
C1: insert into tt1 to fire a trigger to insert a row into hi; --blocked
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
C1: INSERT INTO hi VALUES(1,'111'),(2,'222');
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE TRIGGER tt1_insert BEFORE INSERT ON tt1 EXECUTE INSERT INTO hi(id,col) VALUES(new.id, new.col);
C1: commit work;

/* test case */
C1: INSERT INTO hi VALUES(3,'333');
MC: wait until C1 ready;
C2: UPDATE hi SET id=10  WHERE id=1;
MC: wait until C2 ready;
C1: INSERT INTO tt1 VALUES(1,'call');
MC: wait until C1 blocked;
C2: commit;
C2: SELECT * FROM hi order by id;
MC: wait until C2 ready;
C1: commit;
C1: SELECT * FROM hi order by id;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM hi order by id;
C2: commit;
MC: wait until C2 ready;

/* test case */
C1: INSERT INTO hi VALUES(5,'553');
MC: wait until C1 ready;
C2: UPDATE hi SET id=20  WHERE id=2;
MC: wait until C2 ready;
C1: INSERT INTO tt1 VALUES(4,'call');
MC: wait until C1 ready;
C2: commit;
C2: SELECT * FROM hi order by id;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by id;
C1: commit;
C1: SELECT * FROM hi order by id;
MC: wait until C1 ready;
C2: SELECT * FROM hi order by id;

C2: commit;
C1: commit;
C2: quit;
C1: quit;
