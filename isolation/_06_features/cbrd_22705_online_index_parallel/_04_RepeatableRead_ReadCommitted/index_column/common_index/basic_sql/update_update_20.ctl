

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10)) partition by range(col)(partition p1 values less than('dea'),partition p2  values less than MAXVALUE);
C1: insert into t1 values(1,'abc');insert into t1 values(2,'def');insert into t1 values(4,'ijk');insert into t1 values(5,'abc');
C1: create index idx on t1(id) with online parallel 3; 
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t1;
MC: wait until C1 ready;

C2: create index idx1 on t1(col desc,id desc) with online parallel 2;
MC: wait until C2 blocked;

C1: update t1 set id=id+1 where id<3;
MC: wait until C1 ready;

C3: update t1 set id=id+1 where id>2;
MC: wait until C3 blocked;


C1: select * from t1 order by 1;
C1: commit;

MC: wait until C3 ready;
C3: commit;
C2: commit;

C3: select /*+ recompile */ * from t1 where col >'a' and id>0using index idx1(+);
MC: wait until C3 ready;
C3: commit;
C1: quit;
C2: quit;
C3: quit;

