/*
Priority: 1
Reference case:
Isolation Level: Repeatable Read/Repeatable Read
Author: Bobo

Test Plan: 
Test the scenario that the returned index information is different when use different ways, such as in select and show.

Test Point:
1) The result of select and show are the same
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: drop table if exists t;
C1: CREATE TABLE t( col1 INT, col2 VARCHAR(10),col3 int, col4 int);
C1: create unique index idx on t(col4,col3);
C1: commit;
MC: wait until C1 ready;
C2: drop index idx on t;
MC: wait until C2 ready;
C1: select * from t;
MC: wait until C1 blocked;
C2: commit;
MC: wait until C1 ready;
C1: SELECT * FROM db_index where class_name='t';
C1: show index from t;
C1: commit;
MC: wait until C1 ready;
C2: commit;
C1: quit;
C2: quit;

