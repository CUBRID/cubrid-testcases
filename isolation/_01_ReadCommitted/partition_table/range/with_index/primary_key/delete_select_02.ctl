/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Mandy

Test Point:
C1 delete, C2 select, the affected rows are overlapped.
Check C1 does not block C2

NUM_CLIENTS = 2
C1: delete on table t1
C2: Select on table t1
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int primary key, col varchar(10)) partition by range (id) (partition p1 values less than (10), partition p2 values less than (20));
C1: insert into t1 values(1,'abc'),(9,'def'),(10,'abc'),(11,'gh'),(15,'def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t1 where id<10;
MC: wait until C1 ready;
C2: select * from t1 where id<12 order by 1,2;
MC: wait until C2 ready;
C1: commit;
C2: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

C1: quit;
C2: quit;
