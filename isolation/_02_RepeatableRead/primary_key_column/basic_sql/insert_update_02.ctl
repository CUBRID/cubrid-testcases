/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
user can see all update/delete by itself

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'a');
C1: insert into t values(2,'b');
C1: insert into t values(7,'c');
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* no value */
C2: select * from t order by id;
MC: wait until C2 ready;
C1: delete from t where id=2;
C1: update t set id=2 where id=7;
C1: insert into t values(7,'abc');
MC: wait until C1 ready;

/* expect (1,a)(2,c)(7,abc)*/
C1: select * from t order by id;
C1: rollback;

/* expect (1,a)(2,b)(7,c)*/
C2: select * from t order by id;
C2: commit;          

C2: quit;
C1: quit;

