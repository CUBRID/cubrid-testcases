
MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint ,col char(1000)) partition by range(id)(partition p1 values less than (3),partition p2 values less than MAXVALUE);
C1: insert into t select rownum,rownum||'1' from db_root connect by level<=5;
C1: insert into t select rownum,rownum||'9' from db_root connect by level<=5;
C1: insert into t select rownum,rownum||'6' from db_root connect by level<=5;
C1: insert into t select rownum,rownum||'3' from db_root connect by level<=5;
C1: commit;
MC: wait until C1 ready;


/* test case */
/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t;
MC: wait until C1 ready;

C2: create index idx1 on t(id desc,col desc) with online parallel 2;
MC: wait until C2 blocked;

C3: select TO_BASE64(trim(new_t.col)),trim(SUBSTRING_INDEX(new_t.col,'1',3)),SUBSTRING(new_t.col,1,3), SUBSTR(new_t.col,1,3),rtrim(new_t.col),right(new_t.col,3),reverse(trim(new_t.col)),left(new_t.col,3),lower(trim(new_t.col)),chr(new_t.col) from (select * from t order by 1 desc,2 desc) new_t group by new_t.id having new_t.id>0 ;
MC: wait until C3 blocked;

C1: commit;
MC: wait until C2 unblocked;
MC: wait until C3 ready;

C3: commit;
MC: wait until C3 ready;

C2: commit;
MC: wait until C2 ready;

C1: show indexes from t;
C1: select id,trim(col) from t where id >0 and col!='a' using index idx1(+);
C1: drop table t;
C1: commit work;

C2: quit;
C1: quit;
C3: quit;

