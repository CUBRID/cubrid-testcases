/*
Test Case: delete in trigger & insert
Priority: 1
Reference case:
Author: Lily

Test Point:
when trigger is called, delete statement is executed
there is no index on table;

NUM_CLIENTS = 2
C1: insert into tt1 to fire a trigger to delete a row from hi; 
C2: insert different row into hi; 
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
C1: INSERT INTO hi VALUES(1,'111');INSERT INTO hi VALUES(2,'222');INSERT INTO hi VALUES(3,'333');
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE DELETE FROM hi WHERE id = obj.id;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO tt1 VALUES(1,'test');
MC: wait until C1 ready;
C2: INSERT INTO hi VALUES(2,'test');
C2: SELECT * FROM hi order by 1,2;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by 1,2;
C1: commit;
C1: SELECT * FROM hi order by 1,2;
MC: wait until C1 ready;
C2: SELECT * FROM hi order by 1,2;
C2: commit;
MC: wait until C2 ready;
C1: SELECT * FROM hi order by 1,2;
C1: commit;
MC: wait until C1 ready;
C2: quit;
C1: quit;

