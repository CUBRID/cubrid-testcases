/*
Test Case:  create trigger and drop trigger in ReadCommitted and RepeatableRead modes
Priority: 1
Reference case:
Author: Tonny

Test Point:
create trigger and drop trigger in ReadCommitted and RepeatableRead modes

NUM_CLIENTS = 4
C1: create trigger in ReadCommitted mode; 
C2: drop trigger in ReadCommitted mode;
C1: drop trigger in ReadCommitted mode;
C1: commit;
C2: commit;

C3: create trigger in RepeatableRead mode; 
C4: drop trigger in RepeatableRead mode;
C4: commit;
C3: commit;

*/

MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
MC: wait until C1 ready;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
MC: wait until C2 ready;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT, col VARCHAR(10));
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE TRIGGER trg1 AFTER INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id,obj.col);
C1: CREATE TRIGGER trg2 before update ON tt1 EXECUTE update hi set col=new.col,id=new.id where id=obj.id;
C1: SELECT * FROM db_trig order by 1,2;
C1: insert into tt1 values(0,'run');
C1: commit;
MC: wait until C1 ready;

/* test case */


C2: drop trigger trg1;
MC: wait until C2 ready;

C1: drop trigger trg2;
MC: wait until C1 blocked;

C2: commit;
MC: wait until C2 ready;
MC: wait until C1 ready;

C1: commit;
MC: wait until C1 ready;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;
MC: wait until C3 ready;
C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level repeatable read;
MC: wait until C4 ready;


C3: DROP TABLE IF EXISTS tt1;
C3: DROP TABLE IF EXISTS hi;
C3: CREATE TABLE hi( id INT, col VARCHAR(10));
C3: CREATE TABLE tt1( id INT, col VARCHAR(10));
C3: CREATE TRIGGER trg1 AFTER INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id,obj.col);
C3: CREATE TRIGGER trg2 before update ON tt1 EXECUTE update hi set col=new.col,id=new.id where id=obj.id;
C3: SELECT * FROM db_trig order by 1,2;
C3: insert into tt1 values(0,'run');
C3: commit;
MC: wait until C3 ready;

C4: commit;
C4: SELECT * FROM db_trig order by 1,2;
C4: drop trigger trg1;
C4: drop trigger trg2;
C4: DROP TABLE IF EXISTS tt1;
C4: DROP TABLE IF EXISTS hi;
C4: commit;
MC: wait until C4 ready;

C2: quit;
MC: wait until C2 ready;

C1: quit;
MC: wait until C1 ready;

C4: quit;
MC: wait until C4 ready;

C3: quit;
MC: wait until C3 ready;
