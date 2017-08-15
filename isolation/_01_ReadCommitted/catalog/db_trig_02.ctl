/*
Test Case: insert & insert db_trig 
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 insert db_trig
- C2 insert db_trig
- C3 select db_trig
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;
C2: commit;
C3: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT, col VARCHAR(10));
C1: INSERT INTO hi VALUES(1,'111'),(2,'222'),(3,'333');
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: commit;

/* test case */
C1: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE INSERT INTO hi(id,col) VALUES(obj.id, obj.col);
MC: wait until C1 ready;
C2: CREATE TRIGGER tt1_delete BEFORE DELETE ON tt1 EXECUTE DELETE FROM hi WHERE id = obj.id;
MC: wait until C2 blocked;
C3: select * from db_trig order by 1;
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from db_trig order by 1;
C3: commit;
MC: wait until C3 ready;

C1: CREATE TRIGGER tt1_update1 AFTER UPDATE ON tt1 EXECUTE UPDATE hi SET id=id+10 WHERE id = obj.id;
MC: wait until C1 ready;
C2: CREATE TRIGGER tt1_update2 AFTER UPDATE ON tt1 EXECUTE UPDATE hi SET id=id+10 WHERE id = obj.id;
MC: wait until C2 blocked;
C3: select * from db_trig order by 1;
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from db_trig order by 1;
C3: commit;
MC: wait until C3 ready;
C3: quit;
C2: quit;
C1: quit;
