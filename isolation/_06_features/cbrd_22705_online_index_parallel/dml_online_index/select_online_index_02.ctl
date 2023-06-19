
MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint ,col varchar(1000));
C1: insert into t select rownum,rownum||'1' from db_root connect by level<=10;
C1: insert into t select rownum,rownum||'9' from db_root connect by level<=10;
C1: insert into t select rownum,rownum||'6' from db_root connect by level<=10;
C1: insert into t select rownum,rownum||'3' from db_root connect by level<=10;
C1: insert into t values(20,null);
C1: update statistics on t;
C1: commit;
MC: wait until C1 ready;


/* test case */
/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t;
MC: wait until C1 ready;

C2: create index idx1 on t(id desc,col desc) with online parallel 2;
MC: wait until C2 blocked;

C3: select 
CUME_DIST() OVER(order by id,col),
CUME_DIST() OVER(PARTITION BY id order by col),
DENSE_RANK() OVER(order by id,col),
DENSE_RANK() OVER(PARTITION BY id order by col),
FIRST_VALUE(col) OVER(PARTITION BY id order by col),
LAST_VALUE(col) OVER(PARTITION BY id order by col),
LAG (col, 1) OVER(order by id,col),
LEAD (col, 1) OVER(order by id,col),
NTH_VALUE(col, 2) IGNORE NULLS OVER(PARTITION BY id ORDER BY col NULLS FIRST),
NTILE(5) OVER (ORDER BY id,col),
PERCENT_RANK() OVER(ORDER BY id,col),
PERCENT_RANK() OVER(PARTITION BY col ORDER BY id),
RANK() OVER (PARTITION BY col ORDER BY id DESC),
ROW_NUMBER() OVER (PARTITION BY col ORDER BY id DESC),
STDDEV_POP(id) OVER(PARTITION BY id order by col), 
STDDEV_SAMP(id) OVER(PARTITION BY col order by id ),
VAR_POP(id) OVER(PARTITION BY col order by id),
VAR_SAMP(id) OVER(PARTITION BY col order by id) 
from t order by 1 desc,2,3,4,5,6,7,8 limit 3 ;
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

