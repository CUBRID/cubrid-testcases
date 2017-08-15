/*
Test Case: delete & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_delete_04.ctl
Author: Rong Xu

Test Point:
one user insert, another delete other rows in the same function index nodes

NUM_CLIENTS = 2
C1: insert('abc');
C2: delete from t where col='efg'; --expected no block
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(LENGTH(col));
C1: insert into t values(1,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'efg');
MC: wait until C1 ready;
C2: delete from t where col='abc';
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: commit;
C2: select * from t where LENGTH(col)=3;
C2: commit;

C2: quit;
C1: quit;

