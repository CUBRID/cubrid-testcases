/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
one user insert, another delete rows include the inserted row

NUM_CLIENTS = 2
prepare (3,7)
C1: insert (5)
C2: delete from t where id<=5; --ready, didn't delete 5
C1: commit
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: insert into t values(3,'abc');
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(5,'abc');
MC: wait until C1 ready;
C2: delete from t where id<=7;
MC: wait until C2 ready;
/* expect (3,'abc')(7,'abc')(5,'abc') */
C1: select * from t order by 1;
C1: commit work;
MC: wait until C1 ready;
/* expect no value */
C2: select * from t order by 1;
C2: commit;
/* expect (5,'abc') */
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

