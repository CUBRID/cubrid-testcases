CREATE TABLE t1 (
   a  INT NOT NULL,
   b  VARCHAR(40) NOT NULL,
   c  CHAR(3)
  );
  
CREATE UNIQUE INDEX idx_t1_ac ON t1(a,c);
CREATE INDEX idx_t1_abc ON t1(a,b,c);

insert into t1 values (1, 'Adalius', '086');
insert into t1 values (2, 'Agassi', '086');
insert into t1 values (3, 'Ahman', '086');
insert into t1 values (4, 'Alcott', '086');
insert into t1 values (5, 'Ali', '086');
insert into t1 values (6, 'Bdalius', '011');
insert into t1 values (7, 'Bgassi', '011');
insert into t1 values (8, 'Bhman', '011');
insert into t1 values (9, 'Blcott', '011');
insert into t1 values (10, 'Bli', '011');



prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 order by a limit ?' execute stmt using 2 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 order by a limit ?,?' execute stmt using 1,2 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 order by a limit 1,?' execute stmt using 3 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 order by a limit ?,1' execute stmt using 3 deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum < ? order by a' execute stmt using 3 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum <= ? order by a' execute stmt using 3 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum > 2*? and rownum <= ?*(?+?) order by a' execute stmt using 1,3,1,1 deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum >= 2*? and rownum < sqrt(?) order by a' execute stmt using 1,4 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum >= 2*? and rownum < sqrt(?) order by a' execute stmt using 1,5 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum >= 2*? and rownum < sqrt(?) order by a' execute stmt using 1,8 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum >= 2*? and rownum < sqrt(?) order by a' execute stmt using 1,9 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum >= 2*? and rownum <= sqrt(?) order by a' execute stmt using 1,9 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum > 2*? and rownum < sqrt(?+?*?) order by a' execute stmt using 1,3,1,2 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum > 2*? and rownum < sqrt(?+?*?) order by a' execute stmt using 1,8,4,2 deallocate prepare stmt;

/* -- err */
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum >= 2*? and rownum < sqrt(id) order by a' execute stmt using 1 deallocate prepare stmt;

/* upper keylimit bound results negative, should return 0 results */
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum >= ? and rownum < ? order by a' execute stmt using 3,1 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum >= ? and rownum < ? order by a' execute stmt using 3,-1 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum >= ? and rownum < ? order by a' execute stmt using 3,3 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum >= ? and rownum < ?/? order by a' execute stmt using 3,6,2 deallocate prepare stmt;

select /*+ recompile */ a,b,c from t1 where a > 0 and rownum > 2*1 and sqrt(3+1*2) > rownum order by a;
select /*+ recompile */ a,b,c from t1 where a > 0 and rownum > 2*1 and sqrt(6*5+6) >= rownum order by a;
select /*+ recompile */ a,b,c from t1 where a > 0 and rownum > 2*1 and sqrt(6*5+6) > rownum order by a;
select /*+ recompile */ a,b,c from t1 where a > 0 and (1+1) < rownum and sqrt(6*5+6) >= rownum order by a;
select /*+ recompile */ a,b,c from t1 where a > 0 and (16/4) <= rownum and sqrt(6*5+6) > rownum order by a;


prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum = ? order by a' execute stmt using 0 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum = ? order by a' execute stmt using 1 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum = ? order by a' execute stmt using -1 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,b,c from t1 where a > 0 and rownum = ? order by a' execute stmt using 4 deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 and rownum = ? using index idx_t1_ac(+) keylimit ?,?  order by a' execute stmt using 3,2,4 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 and rownum between ? and ? using index idx_t1_ac(+) keylimit ?,?  order by a' execute stmt using 3,8,1,4 deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?' execute stmt using 0,0,2 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?' execute stmt using 0,3,1 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?' execute stmt using 0,3,2 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?' execute stmt using 0,-1,2 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?' execute stmt using -1,0,2 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?' execute stmt using 0,4,-2 deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?,?' execute stmt using 0,0,0,0 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?,?' execute stmt using 0,0,0,3 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?,?' execute stmt using 0,-1,0,3 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?,?' execute stmt using 0,3,-1,3 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?,?' execute stmt using 1,4,2,5 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?,?' execute stmt using 3,4,1,2 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?,?' execute stmt using 2,5,4,1 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) keylimit ?,?  order by a limit ?,?' execute stmt using 4,1,2,5 deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) order by a limit ?,?' execute stmt using -1,-3 deallocate prepare stmt;
prepare stmt from 'select /*+ recompile */ a,c from t1 where a > 0 using index idx_t1_ac(+) order by a limit ?,?' execute stmt using -3,5 deallocate prepare stmt;

drop table t1;
