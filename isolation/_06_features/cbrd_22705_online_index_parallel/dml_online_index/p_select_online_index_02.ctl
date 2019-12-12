
MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint ,col varchar(1000)) partition by range(id)(partition p1 values less than (5),partition p2 values less than MAXVALUE);
C1: insert into t select rownum,rownum||'1' from db_root connect by level<=10;
C1: insert into t select rownum,rownum||'9' from db_root connect by level<=10;
C1: insert into t select rownum,rownum||'6' from db_root connect by level<=10;
C1: insert into t select rownum,rownum||'3' from db_root connect by level<=10;
C1: insert into t values(20,null);
C1: commit;
MC: wait until C1 ready;


/* test case */
/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t;
MC: wait until C1 ready;

C2: create index idx1 on t(id desc,col desc) with online parallel 2;
MC: wait until C2 blocked;

C3: select CUME_DIST() OVER(order by col),CUME_DIST() OVER(PARTITION BY id order by col),DENSE_RANK() OVER(order by col),DENSE_RANK() OVER(PARTITION BY id order by col),FIRST_VALUE(col) OVER(PARTITION BY id order by col),LAST_VALUE(col) OVER(PARTITION BY id order by col),LAG (col, 1) OVER(order by col),LEAD (col, 1) OVER(order by col),NTH_VALUE(col, 2) IGNORE NULLS OVER(PARTITION BY id ORDER BY id NULLS FIRST),NTILE(5) OVER (ORDER BY col),PERCENT_RANK() OVER(ORDER BY col),PERCENT_RANK() OVER(PARTITION BY col ORDER BY id),RANK() OVER (PARTITION BY col ORDER BY id DESC),ROW_NUMBER() OVER (PARTITION BY col ORDER BY id DESC),STDDEV_POP(id) OVER(PARTITION BY col), STDDEV_SAMP(id) OVER(PARTITION BY col),VAR_POP(id) OVER(PARTITION BY col),VAR_SAMP(id) OVER(PARTITION BY col) from t order by 1 desc limit 3 ;
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

