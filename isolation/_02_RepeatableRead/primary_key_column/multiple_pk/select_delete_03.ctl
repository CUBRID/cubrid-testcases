/*
Test Case: delete & select
Priority: 2
Reference case: 
Author: Lily

Test Point:
C1 select rows, C2 delete rows, not blocked.
C2 update then select

*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: create table t1(id int,col varchar(10), primary key(id,col)) ;
C1: INSERT INTO t1 VALUES(1,'abc'),(12,'edf');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: select * from t1 order by id;
C1: DELETE FROM t1 WHERE id=1;
MC: wait until C1 ready;
C2: select * from t1 order by id;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: select * from t1 order by id;
C2: commit;
C2: UPDATE t1 SET id=1,col='abc' where col='edf';
C2: select * from t1 order by id;
MC: wait until C2 ready;
C1: INSERT INTO t1 VALUES(12,'edf');
MC: wait until C1 blocked;
C2: select * from t1 order by id;
C2: commit;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

C2: select * from t1 order by id;
C2: commit;
C2: quit;
C1: quit;
