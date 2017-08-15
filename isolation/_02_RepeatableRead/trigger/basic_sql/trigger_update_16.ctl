/*
Test Case: update in trigger & update
Priority: 1
Reference case:
Author: Lily

Test Point:
when trigger is called, update statement is executed

NUM_CLIENTS = 2
C1: start transaction;
C2: update a row from hi;
C1: insert into tt1 to fire a trigger to update a row from hi; --blocked
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT , col VARCHAR(10));
C1: INSERT INTO hi VALUES(1,'111'),(2,'222'),(3,'333');
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE TRIGGER tt1_insert BEFORE INSERT ON tt1 EXECUTE UPDATE hi SET col=NULL WHERE id = new.id;
C1: commit work;

/* update same row */
C1: UPDATE hi SET col = 'NULL' WHERE id=3;
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(2,'dev');
C2: UPDATE hi SET col = 'new' WHERE id=1;
MC: wait until C2 ready;
C1: INSERT INTO tt1 VALUES(1,'test');
MC: wait until C1 blocked;
C2: commit;
MC: wait until C1 ready;
C1: SELECT * FROM tt1 ORDER BY id;
C1: SELECT * FROM hi ORDER BY id;
C1: commit work;
MC: wait until C1 ready;
C2: SELECT * FROM hi ORDER BY id;
MC: wait until C2 ready;

/* update different row */
C1: UPDATE tt1 SET col = NULL WHERE id=2;
C2: UPDATE hi SET col = 'new' WHERE id=2;
MC: wait until C2 ready;
C1: INSERT INTO tt1 VALUES(3,'test');
C1: SELECT * FROM hi ORDER BY id;
MC: wait until C1 ready;
C2: SELECT * FROM hi ORDER BY id;
C2: commit;
MC: wait until C2 ready;

C1: SELECT * FROM tt1 ORDER BY id;
C1: SELECT * FROM hi ORDER BY id;
C1: commit work;
MC: wait until C1 ready;
C2: SELECT * FROM hi ORDER BY id;

C2: commit;
C2: quit;
C1: quit;
