--index_skip_scan
drop if exists t1,t2;
CREATE TABLE t1 (id INT PRIMARY KEY, a INT, b INT, c INT);
CREATE TABLE t2 (id INT PRIMARY KEY, a INT, b INT, c INT);
CREATE INDEX i_t1_ac ON t1(a,c);
CREATE INDEX i_t2_ac ON t2(a,c);
INSERT INTO t1 select rownum, rownum, rownum, rownum FROM db_root connect by level<=1000;
INSERT INTO t2 select id, a%5, b, c FROM t1;
UPDATE /*+ INDEX_SS(t1) */t1, t2 set t1.a=10001
WHERE t1.b<5 AND t1.c<5 AND t2.c<5  
USING INDEX i_t1_ac keylimit 1, i_t2_ac keyLIMIT 0+0,2-1;

UPDATE /*+ INDEX_SS */t1, t2 set t1.a=10001
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac keylimit 1, i_t2_ac keylimit 1;

UPDATE /*+ INDEX_SS */t1, t2 set t1.a=10001
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac keylimit 0,1, i_t2_ac keylimit 0,1;

UPDATE /*+ INDEX_SS */t1, t2 set t1.a=10001
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac, i_t2_ac keylimit 0,0+1;

UPDATE /*+ INDEX_SS(t1) */t1, t2 set t1.a=10001
WHERE t1.b<5 AND t1.c<5 AND t2.c<5  
USING INDEX i_t1_ac keylimit 0,1, i_t2_ac keyLIMIT 0,1;
 
UPDATE /*+ INDEX_SS(t1) */t1, t2 set t1.a=10001
WHERE t1.b<5 AND t1.c<5 AND t2.c<5  
USING INDEX i_t1_ac keylimit 1, i_t2_ac keyLIMIT 1;

UPDATE /*+ INDEX_SS */t1, t2 set t1.a=10001
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac, i_t2_ac keylimit 0,0+1;

UPDATE /*+ INDEX_SS(t1) */t1, t2 set t1.a=10001
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac, i_t2_ac keyLIMIT 0+0,2-1;

UPDATE /*+ INDEX_SS(t1) */t1, t2 set t1.a=10001
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac keylimit 1, i_t2_ac keyLIMIT 0+0,2-1;

UPDATE /*+ INDEX_SS(t1) */t1, t2 set t1.a=10001
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac keyLIMIT 0+0,2-1, i_t2_ac keyLIMIT 0+0,2-1;

UPDATE /*+ INDEX_SS(t1, t2) */t1, t2 set t1.a=10001
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac, i_t2_ac keyLIMIT 9-9,1*1;

UPDATE /*+ INDEX_SS(t1, t2) */t1, t2 set t1.a=10001
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac keyLIMIT 9-9,1*1 , i_t2_ac keyLIMIT 9-9,1*1;
drop if exists t1,t2;
