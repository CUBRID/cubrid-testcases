/*
Test Case: select in trigger & insert,update,delete,select
Priority: 1
Reference case:
Author: Lily

Test Point:
when trigger is called, insert statement is executed
there is primary key on table;

NUM_CLIENTS = 4
C1: insert into tt1 to fire a trigger to select table hi; 
C2: insert into hi;
C3: delete from hi;
C4: update from hi; 
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

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT PRIMARY KEY, col VARCHAR(10));
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: INSERT INTO hi values(1,'111'),(2,'222'),(3,'333'),(4,'444');
C1: CREATE TRIGGER tt1_insert BEFORE INSERT ON tt1 IF 4 < (SELECT COUNT(*) FROM hi) EXECUTE REJECT;
C1: commit work;

/* test case */
C1: INSERT INTO tt1 VALUES(2,'done');
MC: wait until C1 ready;
C2: INSERT INTO hi VALUES(5,'test');
MC: wait until C2 ready;
C3: DELETE FROM hi WHERE id=3;
C3: INSERT INTO hi VALUES(9,'run');
MC: wait until C3 ready;
C4: UPDATE hi SET id=id+10 WHERE col='222';
C4: INSERT INTO hi VALUES(8,'rod');
MC: wait until C4 ready;
C1: INSERT INTO tt1 VALUES(3,'RED');
MC: wait until C1 ready;
C1: rollback;
C2: commit work;
C3: commit work;
C4: commit work;
MC: wait until C2 ready;
MC: wait until C3 ready;
MC: wait until C4 ready;
C1: INSERT INTO tt1 VALUES(8,'REJECT');
C1: SELECT * FROM hi order by id;
C1: SELECT * FROM tt1 order by id;
C1: commit;
C4: quit;
C3: quit;
C2: quit;
C1: quit;
