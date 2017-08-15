/*
Test Case: create table & delete,insert,select,update
Priority: 1
Reference case:
Author: Lily

Test Point:
C1: create table;  --uncommitted
C2: insert table;
C3: select table;
C4: update table;
C5: delete table;

*/

MC: setup NUM_CLIENTS = 5;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;
C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;
C5: set transaction lock timeout INFINITE;
C5: set transaction isolation level read committed;
C1: commit;
C2: commit;
C3: commit;
C4: commit;
C5: commit;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10), grade INT);
C1: INSERT INTO tb1 VALUES(2,'abc',10);
MC: wait until C1 ready;
C2: INSERT INTO tb1 VALUES(1,'abc',10);
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: select * from tb1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C4: DROP TABLE IF EXISTS tb1;
C4: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C4: INSERT INTO tb1 VALUES(2,'abc');
MC: wait until C4 ready;
C3: update tb1 set col=NULL where id=2;
MC: wait until C3 blocked;
C4: commit;
MC: wait until C3 ready;
C3: select * from tb1 order by 1,2;
C3: commit;
MC: wait until C3 ready;

C2: DROP TABLE IF EXISTS tb1;
C2: CREATE TABLE tb1(dept_no INT PRIMARY KEY,col VARCHAR(10),ts datetime );
C2: INSERT INTO tb1 VALUES(2,'abc','2013-9-10');
MC: wait until C2 ready;
C4: select * from tb1 order by 1,2;
MC: wait until C4 blocked;
C2: commit;
MC: wait until C4 ready;
C4: commit;
MC: wait until C4 ready;

C4: DROP TABLE IF EXISTS tb1;
C4: CREATE TABLE tb1(id int PRIMARY KEY,col VARCHAR(10),ts datetime );
C4: INSERT INTO tb1 VALUES(2,'abc','2013-9-10');
MC: wait until C4 ready;
C5: delete from tb1 where id=7;
MC: wait until C5 blocked;
C4: commit;
MC: wait until C5 ready;
C5: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;
MC: wait until C4 ready;
C1: quit;
C2: quit;
C3: quit;
C4: quit;
C5: quit;
