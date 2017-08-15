/*
Test Case: update in trigger & insert
Priority: 1
Reference case:
Author: Lily

Test Point:
Event Type:update,   Event time:after, Action: insert

NUM_CLIENTS = 2
C1: update hi to fire a trigger to insert a row in hi;
C2: insert different row into hi; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT PRIMARY KEY, col VARCHAR(10));
C1: INSERT INTO hi VALUES(1,'111');
C1: CREATE TRIGGER trg1 AFTER UPDATE ON hi(col) EXECUTE INSERT INTO hi VALUES(obj.id+10,'trigger');   
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE hi SET col=null;
MC: wait until C1 ready;
C2: INSERT INTO hi VALUES(2,'test');
MC: wait until C2 ready;
C1: SELECT * FROM hi order by 1,2;
MC: wait until C1 ready;
C2: SELECT * FROM hi order by 1,2;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;

C2: SELECT * FROM hi order by 1,2;
C2: DROP TRIGGER trg1;
C2: commit work;

C2: quit;
C1: quit;
