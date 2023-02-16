
MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t2;
C1: drop table if exists t1;
C1: create table t1(id int primary key, col1 char(3000));
C1: insert into t1 values(1,'james'),(2,'mikey'),(3,'lucy'),(5,'nancy'),(6,null);
C1: create table t2(id bigint primary key ,col1 varchar(10),col2 int, constraint foreign key(col2) references t1(id));
C1: insert into t2 select rownum,'a'||rownum,1 from db_root connect by level<=10;
C1: insert into t2 select rownum+10,'b'||rownum,2 from db_root connect by level<=10;
C1: insert into t2 select rownum+20,'c'||rownum,3 from db_root connect by level<=10;
C1: update statistics on t2;
C1: commit;
MC: wait until C1 ready;

/* test case */
/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t2;
MC: wait until C1 ready;

C2: create index idx_t2_col1_col2 on t2(col1 asc,col2 desc) with online parallel 2;
MC: wait until C2 blocked;

C3: insert into t1 values(4,'bob');
MC: wait until C3 ready;

C4: update t2 set col2=4 where id>=25;
MC: wait until C4 blocked;

C1: commit;
MC: wait until C2 unblocked;
MC: wait until C3 ready;
MC: wait until C4 blocked;

/* C2 should be blocked to promote to SCH_M */
MC: wait until C2 blocked;

C3: commit;
MC: wait until C3 ready;

C4: commit;
MC: wait until C4 ready;

C2: commit;
MC: wait until C2 ready;

C1: update statistics on t2;
C1: show indexes from t2;
C1: select /*+ recompile */ * from t2 where col1>40 and col2 >3 using index idx_t2_col1_col2(+) order by 2 asc,3 desc,1 desc;
C1: select /*+ recompile */ * from t2 where col1>40 and col2 >3 using index none order by 2 asc,3 desc,1 desc;
C1: drop table t2,t1;
C1: commit work;

C2: quit;
C1: quit;
C3: quit;
C4: quit;
