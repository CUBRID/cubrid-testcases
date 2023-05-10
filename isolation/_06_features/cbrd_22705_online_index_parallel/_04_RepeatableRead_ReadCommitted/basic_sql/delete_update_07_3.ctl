
MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;



/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT Unique, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE UNIQUE INDEX idx_id on t1(id) with online parallel 7;
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t1;
MC: wait until C1 ready;

C2: create index idx1 on t1(id desc,col desc) with online parallel 2;
MC: wait until C2 blocked;

C1: DELETE FROM t1 WHERE tag BETWEEN 'B' AND 'C' or col IN ('abc','def');
MC: wait until C1 ready;
C3: UPDATE t1 SET id = 7, tag = 'X' WHERE id >= 4 and id <= 5 and tag NOT IN ('E','F','G');
/* expect: C3 needs to wait once C1 completed */
MC: wait until C3 blocked;

/* expect: C1 select - id = 1,2,3,7 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: rollback;
/* expect: a constraint error message should generated once C2 ready, C2 select - no instance is updated */
MC: wait until C3 ready;

C3: commit;
MC: wait until C3 ready;

C2: commit;
MC: wait until C2 ready;

C3: update statistics on t1;
C3: show index from t1;
C3: SELECT /*+ recompile */ * FROM t1 where id>0 and col>'A' using index idx1(+);
C3: SELECT /*+ recompile */ * FROM t1 where id>0 and col>'A' using index none order by id ;
C3: commit;

C1: quit;
C2: quit;
C3: quit;
