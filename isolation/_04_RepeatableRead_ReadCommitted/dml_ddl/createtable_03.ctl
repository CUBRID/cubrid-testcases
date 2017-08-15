/*
Test Case: create table & delete,insert,select,update
Priority: 1
Reference case:
Author: Lily

Test Point:
repeat to create, drop and alter table.
*/

MC: setup NUM_CLIENTS = 5;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10), grade INT);
C1: INSERT INTO tb1 VALUES(2,'abc',10);
C1: select * from db_class where owner_name='PUBLIC';
C1: commit;
MC: wait until C1 ready;
C2: drop table tb1;
C2: CREATE TABLE tb1(No_value INT PRIMARY KEY,col VARCHAR(10));
C2: commit;
MC: wait until C2 ready;

C1: RENAME TABLE tb1 AS tb2;
MC: wait until C1 ready;
C2: CREATE TABLE tb1(No_value INT PRIMARY KEY,col VARCHAR(10));
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: select * from db_class where owner_name='PUBLIC';
C2: drop table tb1; drop table tb2;
C2: commit;
MC: wait until C2 ready;

C1: CREATE TABLE tb1(No_value INT PRIMARY KEY,col VARCHAR(10));
C1: CREATE TABLE tb2(No_value INT PRIMARY KEY,col VARCHAR(10));
C1: commit;
MC: wait until C1 ready;
C2: DROP TABLE IF EXISTS tb1;
C2: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10), grade INT);
C2: INSERT INTO tb1 VALUES(512,'abc',10);
C2: INSERT INTO tb1 SELECT rownum,mod(rownum,100),mod(rownum,100) FROM db_class a,db_class b where rownum<=500;
C2: commit;
MC: wait until C2 ready;

C1: DROP TABLE IF EXISTS tb1; 
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10), grade INT);
C1: select * from tb1 order by 1,2;
C1: commit;
MC: wait until C1 ready;
C2: ALTER TABLE tb1 ADD COLUMN email VARCHAR(20);
C2: commit;
MC: wait until C2 ready;
C1: desc tb1;
C1: commit;
C1: quit;
C2: quit;

