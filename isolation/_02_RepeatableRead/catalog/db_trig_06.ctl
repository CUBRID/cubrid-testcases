/*
Test Case: insert,update,delete & select db_trig 
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 insert db_trig
- C2 update db_trig
- C3 delete db_trig
- C4 select db_trig
*/

MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;
C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level repeatable read;
C2: commit;
C3: commit;
C4: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT, col VARCHAR(10));
C1: CREATE TABLE tt1( id INT primary key, col VARCHAR(10));
C1: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE INSERT INTO hi(id,col) VALUES(obj.id, obj.col);
C1: CREATE TRIGGER tt1_delete BEFORE DELETE ON tt1 EXECUTE DELETE FROM hi WHERE id = obj.id;
C1: commit;

/* test case */
C2: CREATE TRIGGER tt1_update AFTER UPDATE ON tt1 EXECUTE UPDATE hi SET id=id+10 WHERE id = obj.id;
C2: insert into tt1 values(1,'abc');
MC: wait until C2 ready;
C3: rename tt1 as tb1;
MC: wait until C3 blocked;
C1: select * from db_trig order by 1;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C4: drop trigger tt1_delete;
MC: wait until C4 blocked;
C3: commit;
MC: wait until C3 ready;
C4: commit;
MC: wait until C4 ready;
C1: select * from db_trig order by 1;
C1: commit;
C1: select * from db_trig order by 1;
C1: rename tb1 as tt1;
C1: commit;
MC: wait until C1 ready;

C1: insert into tt1 values(1,'bae') ON DUPLICATE KEY UPDATE id=10,col='spe';
MC: wait until C1 ready;
C2: ALTER TRIGGER tt1_insert STATUS INACTIVE;
MC: wait until C2 blocked;
C3: CREATE TRIGGER tt1_delete BEFORE DELETE ON tt1 EXECUTE DELETE FROM hi WHERE id = obj.id+4;
MC: wait until C2 blocked;
C4: select * from db_trig order by 1;
MC: wait until C4 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C4: select * from db_trig order by 1;
C4: commit;
C4: select * from db_trig order by 1;
C4: drop table hi,tt1;
C4: commit;
MC: wait until C4 ready;

C3: quit;
C2: quit;
C1: quit;
C4: quit;
