/*
Test Case: alter view
Priority: 1
Reference case:
Author: Bobo

Test Plan: 
Test update locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenario:
C1 ALTER, C2 ALTER, C3 select
C1 commit, C2 commit, C3 commit
Metrics: data size = small, where clause = simple (multiple columns)

Test Point:
1) C1 and C2 will be waiting 
2) All the data affected from C1 and C2 should be deleted

NUM_CLIENTS = 3
C1: ALTER - update - select;  
C2: ALTER - select;  
C3: select;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: DROP TABLE IF EXISTS t2;
C1: DROP VIEW IF EXISTS t1_view;
C1: DROP VIEW IF EXISTS t2_view;
C1: CREATE TABLE t1(id INT primary key, name VARCHAR(10), phone VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'aaa','111-1111'), (2,'bbb','222-2222'), (3, 'ccc','333-3333'), (4, 'ddd', NULL), (5, 'eee', NULL);
C1: CREATE TABLE t2(id int primary key, name VARCHAR(10));
C1: INSERT INTO t2 VALUES(1,'stu'),(2,'vwx'),(3,'yzab'),(4,'abc');
C1: CREATE TRIGGER t1_insert AFTER INSERT ON t1 EXECUTE INSERT INTO t2 VALUES(obj.id, obj.name);
C1: CREATE TRIGGER t1_update BEFORE UPDATE ON t1 EXECUTE INSERT INTO t2 VALUES(obj.id, 'update');
C1: commit;

C1: CREATE VIEW t1_view AS SELECT t1.id, t1.phone, t2.name FROM t1, t2 WHERE phone IS NOT NULL and t1.id=t2.id;
C1: SELECT * FROM t1_view order by 1,2,3;
MC: wait until C1 ready;
C2: INSERT INTO t1 VALUES(6, 'fff', '666-6666');
MC: wait until C2 ready;
C1: SELECT * FROM t2 order by 1,2;
C1: update t1_view set id=6 where id=3;
MC: wait until C1 ready;
C2: SELECT * FROM t2 order by 1,2;
C2: COMMIT;
MC: wait until C1 ready;
C1: SELECT * FROM t1_view order by 1,2,3;
C1: SELECT * FROM t2 order by 1,2;
C1: COMMIT;
MC: wait until C1 ready;
C2: SELECT * FROM t1_view order by 1,2,3;
C2: SELECT * FROM t2 order by 1,2;
C2: COMMIT;
MC: wait until C2 ready;

C1: quit;
C2: quit;
