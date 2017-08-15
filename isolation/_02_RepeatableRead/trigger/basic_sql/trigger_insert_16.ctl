/*
Test Case: insert in trigger & select
Priority: 1
Reference case:
Author: Lily

Test Point:
when trigger is called, insert statement is executed
there is primary key on table;

NUM_CLIENTS = 2
C1: start transaction;
C2: SELECT * FROM hi order by id;
C1: insert into tt1 to fire a trigger to insert different row into hi; --ready
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
C1: CREATE TRIGGER tt1_insert AFTER INSERT ON tt1 EXECUTE INSERT INTO hi(id,col) VALUES(obj.id+100, obj.col);
C1: commit work;

/* test case */
C1: INSERT INTO tt1 VALUES(3,DEFAULT);
C1: INSERT INTO tt1 SET id=10, col=id||'aa';
MC: wait until C1 ready;
C2: SELECT * FROM hi ORDER BY id;
C2: INSERT INTO tt1 VALUES(11,'call');
C2: INSERT tt1 SELECT * from hi where col is not null;
MC: wait until C2 ready;
C1: commit;
C1: SELECT * FROM hi order by id;
MC: wait until C1 ready;
C2: SELECT * FROM hi order by id;
C2: commit;
MC: wait until C2 ready;
C1: commit;
C1: SELECT * FROM tt1 order by id;
C1: SELECT * FROM hi order by id;
C1: commit;
MC: wait until C2 ready;
C2: SELECT * FROM tt1 order by id;
C2: SELECT * FROM hi order by id;
C2: commit;
C2: quit;
C1: quit;
