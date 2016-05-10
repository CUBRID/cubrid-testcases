/*
Test Case: read & write db_trig 
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 read db_trig
- C2 write db_trig
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT, col VARCHAR(10));
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: commit;

/* test case */
C1: select * from db_trig order by 1;
MC: wait until C1 ready;
C2: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE INSERT INTO hi(id,col) VALUES(obj.id, obj.col);
MC: wait until C2 ready;
C1: select * from db_trig order by 1;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C1: select * from db_trig order by 1;
C1: commit;

C1: CREATE TRIGGER tt1_del AFTER INSERT ON tt1 EXECUTE DELETE FROM hi WHERE id = obj.id;
MC: wait until C1 ready;
C2: select * from db_trig order by 1;
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
C2: select * from db_trig order by 1;
MC: wait until C2 ready;
C2: commit; 

C2: quit;
C1: quit;
