/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
one user insert, another insert, then delete user1's value

NUM_CLIENTS = 2
C1: insert into t values(2,'abc');
C2: insert into t values(3,'abc');
C2: delete from t where id=2;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: insert into t values(1,'abc');
C1: insert into t values(4,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: select * from t order by 1;
MC: wait until C2 ready;
C1: insert into t values(20,'abc');
C1: commit;
MC: wait until C1 ready;
C2: insert into t values(3,'abc');
MC: wait until C2 ready;
/* expect delete 0 row */
C2: delete from t where id=20;
MC: wait until C2 ready;
/* expect (20,'abc')  (1,'abc') (4,'abc') */
C1: select * from t order by 1;
C1: commit work;
MC: wait until C1 ready;
/* expect (3,'abc')  (1,'abc') (4,'abc') */
C2: select * from t order by 1;
C2: commit;
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

