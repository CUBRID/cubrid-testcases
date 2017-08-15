/*
Test Case: related to CUBRIDSUS-15423 
Priority: 1
Reference case:
Author: Lily

Test Point:
[MVCC] core dumped by lock_suspend: Assertion `!pgbuf_has_perm_pages_fixed (thread_p)' failed.

*/

/* preparation */
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C1: commit;
C2: commit;

/* test case */
C1: create table t1 (id int not null,primary key (id));
C1: create table t2 (t1_id int not null,col varchar(10));
C1: alter table t2 add foreign key (t1_id) references t1 (id);
C1: commit;
MC: wait until C1 ready;
C2: alter table t2 drop constraint fk_t2_t1_id;
C2: insert into t2 values(1,'test');
C2: commit;
C2: insert into t1 values(1);
MC: wait until C2 ready;
C1: alter table t2 add foreign key (t1_id) references t1 (id);
MC: wait until C1 blocked;
C2: commit;
MC: wait until C1 ready;
C1: select * from t1;
C1: commit;
C2: quit;
C1: quit;
