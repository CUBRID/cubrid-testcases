--index_skip_scan
--delete not use index ,correct or error?
drop if exists t1,t2;
CREATE TABLE t1 (id INT PRIMARY KEY, a INT, b INT, c INT);
CREATE TABLE t2 (id INT PRIMARY KEY, a INT, b INT, c INT);
CREATE INDEX i_t1_ac ON t1(a,c);
CREATE INDEX i_t2_ac ON t2(a,c);
INSERT INTO t1 select rownum, rownum, rownum, rownum FROM db_root connect by level<=100;
INSERT INTO t2 select id, a%5, b, c FROM t1;

delete /*+ INDEX_SS(t1) */ FROM t1
WHERE t1.b<5 AND t1.c<5 
USING INDEX i_t1_ac keyLIMIT 0+0,2-1;
select * from t1 order by 1 limit 10;

delete /*+ INDEX_SS */ FROM t2
WHERE t2.c<5
USING INDEX i_t2_ac keylimit 1;
select * from t2 order by 1 limit 10;

delete /*+ INDEX_SS */ FROM t1
WHERE t1.b<10 AND t1.c<10
USING INDEX i_t1_ac keylimit 0,1;
select * from t1 order by 1 limit 10;

delete /*+ INDEX_SS(t2) */ FROM t2
WHERE t2.c<10  
USING INDEX i_t2_ac keyLIMIT 0,1;
select * from t2 order by 1 limit 10;
 
delete /*+ INDEX_SS(t1) */ FROM t1
WHERE t1.b<15 AND t1.c<15  
USING INDEX i_t1_ac keylimit 1;
select * from t1 order by 1 limit 10;

--not support
--delete /*+ INDEX_SS */ FROM t2 WHERE t2.c<15 USING INDEX i_t2_ac limit 0,0+1;
--select * from t2 order by 1 limit 10;

delete /*+ INDEX_SS */ FROM t1
WHERE t1.b<20 AND t1.c<20
USING INDEX i_t1_ac keylimit 0,0+1;
select * from t1 order by 1 limit 10;

delete /*+ INDEX_SS(t1) */ FROM t2
WHERE t2.c<20
USING INDEX i_t2_ac keyLIMIT 0+0,2-1;
select * from t2 order by 1 limit 10;

delete /*+ INDEX_SS(t1) */ FROM t1
WHERE t1.b<25 AND t1.c<25
USING INDEX i_t1_ac keyLIMIT 0+0,2-1;
select * from t1 order by 1 limit 10;

delete /*+ INDEX_SS(t2) */ FROM t2
WHERE t2.c<25
USING INDEX i_t2_ac keyLIMIT 9-9,1*1;
select * from t2 order by 1 limit 10;

delete /*+ INDEX_SS(t1) */ FROM t1
WHERE t1.b<35 AND t1.c<35
USING INDEX i_t1_ac keyLIMIT 9-9,1*1;
select * from t1 order by 1 limit 10;

prepare stmt from 'delete /*+ INDEX_SS(t1) */ FROM t1 WHERE t1.b<45 AND t1.c<45 USING INDEX i_t1_ac keyLIMIT ?-?,?*?';
execute stmt using 9,9,1,1;
select * from t1 order by 1 limit 10;

prepare stmt from 'delete /*+ INDEX_SS(t2) */ FROM t2 WHERE t2.c<45 USING INDEX i_t2_ac keyLIMIT ?-?,?*?';
execute stmt using 9,9,1,1;
select * from t2 order by 1 limit 10;
deallocate prepare stmt;
drop if exists t1,t2;
