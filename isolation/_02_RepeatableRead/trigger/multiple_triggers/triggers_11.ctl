/*
Test Case: trigger's commit or rollback 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/trigger/multiple_triggers/triggers_10.ctl
Author: Lily

Test Point:
statement of creating a trigger is committed or rollbacked.

NUM_CLIENTS = 2
C1: create a trigger on tt1; --rollback
C2: insert a row into tt1; 
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
C1: INSERT INTO hi VALUES(1,'111'),(2,'222'),(3,'333'),(4,'444'),(5,'555');
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: CREATE TRIGGER trg1 AFTER INSERT ON tt1 EXECUTE DELETE FROM hi WHERE id=obj.id;
C1: INSERT INTO tt1 VALUES(1,'test');
C1: INSERT INTO tt1 VALUES(3,'run');
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(2,'make');
MC: wait until C2 blocked;
C1: rollback;

MC: wait until C2 ready;
C2: SELECT * FROM hi ORDER BY id;
C2: INSERT INTO tt1 VALUES(4,'do');
C2: SELECT * FROM hi ORDER BY id;
C2: commit;
C2: INSERT INTO tt1 VALUES(5,'find');
C2: SELECT * FROM hi ORDER BY id;
C2: commit;
C2: quit;
C1: quit;
