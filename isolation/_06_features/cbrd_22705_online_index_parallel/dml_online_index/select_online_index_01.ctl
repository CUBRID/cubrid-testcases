
MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint ,col char(1000));
C1: insert into t select rownum,rownum||'1' from db_root connect by level<=10;
C1: insert into t select rownum,rownum||'9' from db_root connect by level<=10;
C1: insert into t select rownum,rownum||'6' from db_root connect by level<=10;
C1: insert into t select rownum,rownum||'3' from db_root connect by level<=10;
C1: update statistics on t;
C1: commit;
MC: wait until C1 ready;


/* test case */
/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t;
MC: wait until C1 ready;

C2: create index idx1 on t(id desc,col desc) with online parallel 2;
MC: wait until C2 blocked;

C3: select max(trim(new_t.col)),min(trim(new_t.col)),avg(new_t.col),group_concat(trim(new_t.col)) ,median(new_t.col),count(new_t.col),sum(new_t.col) from (select * from t order by 1 desc,2 desc) new_t group by new_t.id having new_t.id>5 ;
MC: wait until C3 blocked;

C1: commit;
MC: wait until C2 unblocked;
MC: wait until C3 ready;

C3: commit;
MC: wait until C3 ready;

C2: commit;
MC: wait until C2 ready;

C1: update statistics on t;
C1: show indexes from t;
C1: select id,trim(col) from t where id >5 and col!='a' using index idx1(+) order by 1 desc,2 desc;
C1: drop table t;
C1: commit work;

C2: quit;
C1: quit;
C3: quit;

