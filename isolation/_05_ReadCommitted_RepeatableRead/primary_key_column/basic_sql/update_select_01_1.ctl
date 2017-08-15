/*
Test Case: update & select
Priority: 1
Reference case:
Author: Lily

NUM_CLIENTS = 2
C1: update tb1;
C2: select on table t1 before C1 commit
C1: re-update same row of tb1
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists tb1;
C1: CREATE TABLE tb1( col1 INT primary key, col2 VARCHAR(10),col3  VARCHAR(20), col4 int);
C1: insert into tb1 values(1,'tea','2012-9-8',NULL);
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update tb1 set col4=22 where col2='tea';  
MC: wait until C1 ready;
C2: select * from tb1 order by col1;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: select * from tb1 order by col1;
MC: wait until C2 ready;
C1: update tb1 set col4=232 where col2='tea'; 
MC: wait until C1 ready;
C2: select * from tb1 order by col1;
C2: commit;
C2: select * from tb1 order by col1;
C2: commit;
C1: commit;
C1: quit;
C2: quit;

