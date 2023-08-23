
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
C1: drop table if exists t;
C1: create table t(id bigint unique, a char(10) unique, b varchar(10) unique, c timestamp default current_timestamp, d datetime default current_datetime);
C1: insert into t(id,a,b) select rownum,rownum||'a',rownum||'b' from db_root connect by level<=100;
C1: update statistics on t;
C1: commit;
MC: wait until C1 ready;


/* test case */
/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t;
MC: wait until C1 ready;

C2: create index idx1 on t(a asc,b desc,c asc,d desc) with online parallel 3;
MC: wait until C2 blocked;

C3: insert into t values (-1,'a','b','2000-01-01 18:00:00','2000-01-01 18:00:00') on duplicate key update id=-10;
MC: wait until C3 blocked;

C4: insert into t(id,a,b) values (-2,'1a','1b') on duplicate key update id=-9 ,a='-9a',b='-9b',c='2000-01-01 19:00:00',d='2000-01-01 19:00:00'; 
MC: wait until C4 blocked;


C1: commit;
MC: wait until C2 unblocked;

/* C2 starts scan and will demote to IX. C3 and C4 will resume */

MC: wait until C3 ready;
MC: wait until C4 ready;

/* C2 should be blocked to promote to SCH_M */
MC: wait until C2 blocked;

C3: commit;
MC: wait until C3 ready;
MC: wait until C4 ready;

C4: commit;
MC: wait until C4 ready;


C2: commit;
MC: wait until C2 ready;

C1: update statistics on t;
C1: show index from t;
C1: select /*+ recompile */* from t where a<'1' and b<'1b'  using index idx1(+);

C1: drop table t;
C1: commit;

C2: quit;
C1: quit;
C3: quit;
C4: quit;

