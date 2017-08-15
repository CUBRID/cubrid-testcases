/*
Test Case: create trigger
Priority: 1
Reference case:
Author: Lily

Test point:
system table - db_trig
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT, col VARCHAR(10));
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: commit work;
MC: wait until C1 ready;

/* test case 1 */
C1: CREATE TRIGGER trg1 AFTER INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(obj.id,obj.col);
C1: CREATE TRIGGER trg2 before update ON tt1 EXECUTE update hi set col=new.col,id=new.id where id=obj.id;
C1: SELECT * FROM db_trig order by 1,2;
C1: insert into tt1 values(0,'run');
C1: commit;
MC: wait until C1 ready;

C2: drop trigger trg1;
MC: wait until C2 ready;

C1: drop trigger trg2;
MC: wait until C1 blocked;

C2: SELECT * FROM db_trig order by 1,2;
C2: commit;
MC: wait until C2 ready;
MC: wait until C1 ready;

C1: commit;
MC: wait until C1 ready;

C2: SELECT * FROM db_trig order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
