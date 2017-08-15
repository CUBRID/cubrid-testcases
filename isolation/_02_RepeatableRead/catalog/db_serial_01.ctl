/*
Test Case: read & write db_serial  
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 write db_serial
- C2 read db_serial 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;
C1: CREATE TABLE tb1(id INT primary key,col VARCHAR(10));
C1: commit;

/* test case */
C1: CREATE SERIAL s1 START WITH 100;
C1: insert into tb1 values(s1.next_value,'abcd');
MC: wait until C1 ready;
C2: select name, current_val, increment_val, max_val, min_val, cyclic, started, class_name, att_name, cached_num, comment from db_serial;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: select name, current_val, increment_val, max_val, min_val, cyclic, started, class_name, att_name, cached_num, comment from db_serial;
C2: commit;
C2: select name, current_val, increment_val, max_val, min_val, cyclic, started, class_name, att_name, cached_num, comment from db_serial;
C2: commit;
MC: wait until C2 ready;

C1: CREATE SERIAL s2 START WITH 10;
C1: insert into tb1 values(s2.next_value,'efg');
MC: wait until C1 ready;
C2: select name, current_val, increment_val, max_val, min_val, cyclic, started, class_name, att_name, cached_num, comment from db_serial;
MC: wait until C2 blocked;
MC: sleep 2;
C1: rollback;
MC: wait until C2 ready;
C2: commit;
C2: select name, current_val, increment_val, max_val, min_val, cyclic, started, class_name, att_name, cached_num, comment from db_serial;
C2: select * from tb1;
C2: drop serial s1;
C2: commit;

C2: quit;
C1: quit;
