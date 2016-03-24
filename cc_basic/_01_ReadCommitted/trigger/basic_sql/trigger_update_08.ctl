/*
Test Case: update in trigger & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/trigger/basic_sql/trigger_update_01.ctl
Author: Lily

Test Point:
when trigger is called, update statement is executed
there is primary key on tables;

NUM_CLIENTS = 2
C1: insert into tt1 to fire a trigger to update a row in hi;
C2: update same row from hi; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: DROP TABLE IF EXISTS hi;
C1: CREATE TABLE hi( id INT PRIMARY KEY, col VARCHAR(10));
C1: INSERT INTO hi VALUES(1,'111'),(2,'222'),(3,'333');
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE UPDATE hi SET id=id+10 WHERE id = obj.id;
C1: commit work;

/* test case */
C1: INSERT INTO tt1 VALUES(1,'test');
MC: wait until C1 ready;
C2: UPDATE hi SET col='test' WHERE id=1;
MC: wait until C2 blocked;
C1: commit;
C1: SELECT * FROM hi order by 1,2;
C2: SELECT * FROM hi order by 1,2;
C2: commit work;

C2: quit;
C1: quit;
