/*
Test Case: related to CUBRIDSUS-14764 ( select is blocked by update )  
Priority: 1
Reference case:
Author: Zhan Lanlan

Test Point:
C1: update toys set name='ship';
C2: select * from toys; --select is blocked,Expected is that C2 succeed to select. 

*/

/* preparation */
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;
 
C1: drop table if exists toys;
C1: CREATE TABLE toys (id int NOT NULL,name character varying(36));
C1: INSERT INTO toys(id,name) VALUES(1,'car'),(2,'digger'),(3,'shovel');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update toys set name='ship';
MC: wait until C1 ready;
C2: select * from toys order by 1,2;
MC: wait until C2 ready;


C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: set transaction isolation level repeatable read;
C1: drop table if exists toys;
C1: CREATE TABLE toys (id int NOT NULL,name character varying(36));
C1: INSERT INTO toys(id,name) VALUES(1,'car'),(2,'digger'),(3,'shovel');
C1: commit;
MC: wait until C1 ready;

C2: set transaction isolation level repeatable read;
C2: commit;
MC: wait until C2 ready;

/* test case */
C1: update toys set name='ship';
MC: wait until C1 ready;
C2: select * from toys order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
