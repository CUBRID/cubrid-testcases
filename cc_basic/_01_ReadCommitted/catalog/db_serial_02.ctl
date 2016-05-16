/*
Test Case: insert,update,delete & select db_serial  
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 insert db_serial
- C2 update db_serial
- C3 delete db_serial
- C4 select db_serial 
*/

MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;
C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;
C2: commit;
C3: commit;
C4: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;
C1: CREATE TABLE tb1(id INT primary key,col VARCHAR(10));
C1: CREATE SERIAL s1 START WITH 100;
C1: commit;

/* test case */
C1: CREATE SERIAL s2 START WITH 100 MINVALUE 100;
C1: CREATE SERIAL s3 START WITH 100 INCREMENT BY 2 CACHE 3;
MC: wait until C1 ready;
C2: ALTER SERIAL s1 START WITH 200 MAXVALUE 500;
MC: wait until C2 ready;
C3: drop SERIAL s1;
MC: wait until C3 blocked; 
C4: select name, current_val, increment_val, max_val, min_val, cyclic, started, class_name, att_name, cached_num, comment from db_serial;
MC: wait until C4 blocked;

C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C4: commit;
MC: wait until C4 ready;
C3: commit;
MC: wait until C3 ready;
C4: select name, current_val, increment_val, max_val, min_val, cyclic, started, class_name, att_name, cached_num, comment from db_serial;
C4: commit;
MC: wait until C4 ready;

C2: drop SERIAL s2;
MC: wait until C2 ready;
C3: drop SERIAL s3;
MC: wait until C3 ready;
C1: select name, current_val, increment_val, max_val, min_val, cyclic, started, class_name, att_name, cached_num, comment from db_serial;
MC: wait until C1 blocked;
MC: sleep 2;
C2: rollback;
MC: wait until C2 ready;
C3: rollback;
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;

C1: select name, current_val, increment_val, max_val, min_val, cyclic, started, class_name, att_name, cached_num, comment from db_serial;
C1: drop serial s2;
C1: drop serial s3;
C1: commit;
MC: wait until C1 ready;
C4: quit;
C3: quit;
C2: quit;
C1: quit;
