/*
Test Case: trigger's commit or rollback 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/trigger/multiple_triggers/triggers_10.ctl
Author: Lily

Test Point:
statement of creating a trigger is committed or rollbacked.

NUM_CLIENTS = 2
C1: create a trigger on tt1; 
C1: commit;
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
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE TRIGGER trig_1 BEFORE INSERT ON tt1 EXECUTE INSERT INTO hi VALUES (new.id,new.col);
C1: CREATE TRIGGER trig_2 BEFORE UPDATE ON tt1 EXECUTE INSERT INTO hi VALUES (obj.id,obj.col);
C1: CREATE TRIGGER trig_3 BEFORE DELETE ON tt1 EXECUTE INSERT INTO hi VALUES (obj.id,obj.col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO tt1 VALUES(1,'test');
C1: update tt1 set col='dev' where id=1;
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(3,'run');
C2: insert into tt1 values(4,'work'),(5,'study'),(6,'sleep');
C2: delete from tt1 where id=6;
C2: select * from hi order by id;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(2,'make');
C2: select * from hi order by id;
C2: commit;
C2: SELECT * FROM tt1 ORDER BY id;
C2: SELECT * FROM hi ORDER BY id;
MC: wait until C2 ready;
C1: SELECT * FROM tt1 ORDER BY id;
C1: SELECT * FROM hi ORDER BY id;
C2: commit;
C1: commit;
C2: quit;
C1: quit;
