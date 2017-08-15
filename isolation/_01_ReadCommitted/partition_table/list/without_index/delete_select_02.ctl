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
C1: create table t1(id int, col varchar(10)) partition by list (id) (partition p1 values in (1,3,5,7), partition p2 values in (2,4,6,8));
C1: insert into t1 values(1,'abc'),(2,'def'),(3,'abc'),(4,'def'),(5,'gh'),(6,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t1 where id in (1,2,3);
MC: wait until C1 ready;
C2: select * from t1 where id<6 order by 1,2;
MC: wait until C2 ready;
C1: commit;
C2: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

C1: quit;
C2: quit;
