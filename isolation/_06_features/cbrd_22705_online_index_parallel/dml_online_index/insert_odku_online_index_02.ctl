
MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint primary key, a char(10), b varchar(10), c timestamp default current_timestamp, d datetime default current_datetime);
C1: insert into t(id,a,b) select rownum,rownum||'a',rownum||'b' from db_root connect by level<=10;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: describe t;
MC: wait until C1 ready;

C2: create index idx1 on t(a asc,b desc,c asc,d desc) with online parallel 2 ;
MC: wait until C2 blocked;

C3: insert into t values (10,'11a','11b','2000-01-01 18:00:00','2000-01-01 18:00:00') on duplicate key update id=id+1;
MC: wait until C3 blocked;

C1: commit;
MC: wait until C2 unblocked;

MC: wait until C3 ready;
MC: wait until C2 blocked;

C3: commit;
MC: wait until C3 ready;

C2: commit;
MC: wait until C2 ready;


/* verification */
C1: update statistics on t;
C1: show index from t;
C1: select a,b,id from t where a<'8' and b<'85' order by 1;
MC: wait until C1 ready;

/* exit */
C1: DROP table t;
C1: commit;

C1: quit;
C2: quit;
C3: quit;


