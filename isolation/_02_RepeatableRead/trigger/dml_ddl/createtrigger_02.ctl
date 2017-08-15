/*
Test Case: create trigger
Priority: 1
Reference case:
Author: Lily

Test Point:
create trigger, then fire the trigger in other transaction.

*/
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C1: drop table if exists hi, tt1;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
 
C1: CREATE TABLE hi( id INT, col VARCHAR(10));
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: commit;
C1: CREATE TRIGGER trg1 AFTER INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id,obj.col);
C1: SELECT * FROM db_trig;
C1: commit;
MC: wait until C1 ready;
C2: drop trigger trg1;
C2: CREATE TRIGGER trg1 AFTER INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id,obj.col);
C2: commit;
MC: wait until C2 ready;
C1: SELECT * FROM db_trig;
C1: drop trigger trg1; --expected is successful to drop
C1: CREATE TRIGGER trg1 AFTER INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id,obj.col);
C1: SELECT * FROM db_trig;
C1: commit;
MC: wait until C1 ready;

C2: drop trigger trg1;
C2: commit;
MC: wait until C2 ready;
 
C1: quit;
C2: quit;
