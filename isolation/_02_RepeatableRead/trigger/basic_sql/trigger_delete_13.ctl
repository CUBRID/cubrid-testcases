/*
Test Case: delete in trigger & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/trigger/basic_sql/trigger_delete_01.ctl
Author: Lily

Test Point:
when trigger is called, delete statement is executed
there is primary key on table;

NUM_CLIENTS = 2
C1: start transaction;
C2: delete a row from hi;
C1: insert into tt1 to fire a trigger to delete same row from hi; --blocked
C2: rollback;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT PRIMARY KEY, col VARCHAR(10));
C1: INSERT INTO hi VALUES(1,'111'),(2,'22'),(3,'333');
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE DELETE FROM hi WHERE id = obj.id;
C1: commit work;

/* test case */
C1: UPDATE hi SET col=NULL WHERE id=3;
MC: wait until C1 ready;
C2: DELETE FROM hi WHERE id=1;
MC: wait until C2 ready;
C1: INSERT INTO tt1 VALUES(1,'test');
MC: wait until C1 blocked;
C2: rollback;
MC: wait until C1 ready;
C2: SELECT * FROM hi ORDER BY id;
MC: wait until C2 ready;
C1: rollback;
C1: SELECT * FROM hi ORDER BY id;
C1: SELECT * FROM tt1 ORDER BY id;
C1: commit;

/* test case */
C1: UPDATE hi SET col=NULL WHERE id=3;
MC: wait until C1 ready;
C2: UPDATE hi SET id = 10 WHERE id=1;
MC: wait until C2 ready;
C1: INSERT INTO tt1 VALUES(1,'test');
MC: wait until C1 blocked;
C2: commit;
MC: wait until C1 ready;
C2: SELECT * FROM hi ORDER BY id;
C2: commit;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM hi ORDER BY id;
C2: SELECT * FROM tt1 ORDER BY id;

C2: commit;
C2: quit;
C1: quit;
