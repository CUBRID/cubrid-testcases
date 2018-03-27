/*
Test Case: update in trigger & insert
Priority: 1
Reference case:
Author: Lily

Test Point:
Event Type:insert,   Event time:after, Action: insert
trigger failed to execute because of recursive trigger calling .
NUM_CLIENTS = 2
C1: insert into hi to fire a trigger to insert a row in hi;
C2: insert different row into hi; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS hi;
C1: DROP TABLE IF EXISTS tt1;
C1: CREATE TABLE hi( id INT PRIMARY KEY, col VARCHAR(10));
C1: CREATE TABLE tt1( id INT PRIMARY KEY, col VARCHAR(10));
C1: CREATE TRIGGER trg1 AFTER INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id+10,'trigger');   
C1: commit work;

/* test case */
C1: INSERT INTO tt1 VALUES(1,'111');
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(2,'test');
MC: wait until C2 ready;
C1: INSERT INTO tt1 VALUES(2,'222');
MC: wait until C1 blocked;
C2: INSERT INTO tt1 VALUES(1,'tea');
C2: SELECT * FROM hi order by id;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by id;
C1: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: commit;
C2: SELECT * FROM hi order by id;
C2: SELECT * FROM tt1 order by id;
C2: commit work;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by id;
C1: SELECT * FROM tt1 order by id;
C1: commit work;
MC: wait until C1 ready;

C2: quit;
C1: quit;
