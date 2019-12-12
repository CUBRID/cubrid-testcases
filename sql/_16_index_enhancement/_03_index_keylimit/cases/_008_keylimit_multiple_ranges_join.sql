
--+ holdcas on;

CREATE TABLE ta (
  ta_a       BIGINT NOT NULL,
  ta_b       BIGINT NOT NULL,
  ta          STRING NOT NULL,
  PRIMARY KEY (ta_a, ta_b)
);

CREATE SERIAL ser CACHE 100;

CREATE TABLE tb (
  t_date           DATETIME NOT NULL,
  t_code        STRING NOT NULL, 
  t_name        STRING NOT NULL, 
  t_id     BIGINT NOT NULL, 
  t_desc      STRING NOT NULL, 
  t_flag  STRING NOT NULL,
  t_com STRING, 
  PRIMARY KEY (t_code)
);
CREATE INDEX tb_idx ON tb (t_date);

CREATE TABLE tc (
  t_date           DATETIME NOT NULL,
  tc_code        STRING NOT NULL, 
  tc_flag CHAR(1) NOT NULL, 
  tc_id        STRING NOT NULL,
  t_code        STRING NOT NULL, 
  PRIMARY KEY (t_code, tc_code)
);
CREATE INDEX tc_idx ON tc (t_date);

CREATE TABLE td (
  ta_a       BIGINT NOT NULL,
  ta_b       BIGINT NOT NULL,
  ta          STRING NOT NULL,
  t_date          DATETIME NOT NULL,
  t_code       STRING NOT NULL, 
  t_id    BIGINT NOT NULL DEFAULT 0, 
  td_flag       CHAR(1) NOT NULL,
  td_flag1 CHAR(1), 
  PRIMARY KEY (ta_a, ta_b, t_code)
);
CREATE INDEX td_idx_ab ON td (ta_a, ta_b);
CREATE INDEX td_idx ON td (t_date);


CREATE TABLE te (
  ta_a        BIGINT NOT NULL,
  ta_b        BIGINT NOT NULL,
  ta           STRING NOT NULL,
  t_date           DATETIME NOT NULL,
  te_id           BIGINT NOT NULL,
  t_code        STRING NOT NULL, 
  tc_code        STRING NOT NULL, 
  te_com          STRING NOT NULL,
  te_date1      DATETIME NOT NULL,
  te_date2      DATETIME NOT NULL, 
  te_str1    STRING NOT NULL,
  te_str2   STRING,
  te_id1    STRING NOT NULL, 
  te_ch1        CHAR(1) NOT NULL, 
  te_ch2       CHAR(1) NOT NULL,
  te_date3     DATETIME NOT NULL, 
  te_str3  STRING,
  te_flag       CHAR(1) DEFAULT 'N', 
  PRIMARY KEY (ta_a, ta_b, te_id)
);
CREATE INDEX te_idx_ab ON te (ta_a, ta_b);
CREATE INDEX te_idx ON te (t_date);
CREATE INDEX te_idx_1
  ON te (ta_a, ta_b, te_flag, te_ch1, t_code, te_date1 DESC);
CREATE INDEX te_idx_2
  ON te (ta_a, ta_b, t_code, te_flag, te_ch1, te_ch2);
CREATE INDEX te_idx_3
  ON te (ta, te_flag, te_ch1, t_code, te_date1 DESC);

create index  te_idx_4 on te(ta_a, ta_b, t_code, te_ch1, te_flag, te_date1);
  
COMMIT;

/* tb : 10 records */
INSERT INTO tb
  SELECT SYS_DATETIME, TO_CHAR(i),
         'svc_nm~123456789012345678901234567890', 0,
         'svc_desc~123456789012345678901234567890123456789012345678901234567890',
         'N', 'extnl_svc_url~12345678901234567890123456789012345678901234567890'
  FROM TABLE({0,1}) t(i);
COMMIT;




INSERT INTO tc
  SELECT SYS_DATETIME, TO_CHAR(i), 'Y',
         'itm_nm~123456789012345678901234567890',
         t_code
  FROM tb, TABLE({0,1}) t(i);
COMMIT;
/* tc : 100 records : # of tb(=10) * 10 */

INSERT INTO ta
  SELECT CAST(SQRT(TO_NUMBER(ck)) AS BIGINT),
         CAST(TO_NUMBER(ck) * PI() AS BIGINT),
         ck
  FROM (
    SELECT TO_CHAR(t0.i) || TO_CHAR(t1.i) || TO_CHAR(t2.i)
           || TO_CHAR(t2.i) || TO_CHAR(t1.i) || TO_CHAR(t3.i)
           || TO_CHAR(t0.i) || TO_CHAR(t1.i) || TO_CHAR(t2.i)
           || TO_CHAR(t2.i) || TO_CHAR(t1.i) || TO_CHAR(t3.i)
    FROM TABLE({1,2,3, 4}) t0(i),
         TABLE({0,1,2}) t1(i),
         TABLE({0,1,2}) t2(i),
         TABLE({0,1,2}) t3(i)
    ) t(ck);
COMMIT;

/* td : 40,000 records = # of ta(=4000) * # of tb(=10) */
INSERT INTO td
  SELECT ta_a, ta_b, ta, SYS_DATETIME,
         t_code, 0, 'Y', 'N'
  FROM ta, tb;
COMMIT;


INSERT INTO te
  SELECT c.ta_a, c.ta_b, c.ta, SYS_DATETIME,
         ser.NEXT_VALUE, i.t_code, i.tc_code,
         'cont~123456789012345678901234567890123456789012345678901234567890',
         SYS_DATETIME - (ROWNUM - MOD(19101984, ROWNUM)) * 1000,
         SYS_DATETIME - (ROWNUM - MOD(19101984, ROWNUM)) - 1000,
         'obj_wrg_id~123456789012345678901234567890',
         'obj_wrg_url~12345678901234567890123456789012345678901234567890',
         'snd_svr_ip', 'N', 'N',
         SYS_DATETIME,
         'rss_splyr_nm~123456789012345678901234567890', 'Y'
  FROM ta c, tc i,
       TABLE({0,1,2,3,4,5,6,7}) t0(i),
       TABLE({0,1,2,3,4,5,6,7}) t1(i)
  WHERE TO_NUMBER(i.tc_code) = 1
        AND TO_NUMBER(i.t_code) = 0;
COMMIT;


create table dummy as select 1,2 from te, TABLE({1,2,3,4,5,6,7,8,9,10,11,12,13}) as t;
drop table dummy;


SELECT m.t_code, m.tc_code,  
       m.te_com, m.te_ch2, m.te_str2, s.t_name
FROM te m, td c, tb s
WHERE m.ta_a=641180 AND m.ta_b=1291547730549
      AND c.ta_a=641180 AND c.ta_b=1291547730549
      AND m.t_code = c.t_code
      AND m.t_code = s.t_code
      AND m.t_code IN ('0', '1', '2', '3', '4', '5', '6')
      AND m.te_ch1 = 'N'
      AND m.te_flag = 'Y'
      AND c.td_flag = 'Y'
      AND ((s.t_flag ='Y' AND c.td_flag1= 'Y')
           OR s.t_flag ='N')
      AND m.te_date1 <= SYS_DATETIME
using index te_idx_1 (+)
ORDER BY m.te_date1 DESC
LIMIT 2;


SELECT m.t_code, m.tc_code,  
       m.te_com, m.te_ch2, m.te_str2, s.t_name
FROM te m, td c, tb s
WHERE m.ta_a=641180 AND m.ta_b=1291547730549
      AND c.ta_a=641180 AND c.ta_b=1291547730549
      AND m.t_code = c.t_code
      AND m.t_code = s.t_code
      AND m.t_code  = '0'
      AND m.te_ch1 IN ('N', 'Y')
      AND m.te_flag = 'Y'
      AND c.td_flag = 'Y'
      AND ((s.t_flag ='Y' AND c.td_flag1= 'Y')
           OR s.t_flag ='N')
      AND m.te_date1 <= SYS_DATETIME
using index te_idx_1 (+)
ORDER BY m.te_date1 DESC
LIMIT 2;


SELECT m.t_code, m.tc_code,
       m.te_com, m.te_ch2, m.te_str2
FROM te m
WHERE m.ta = '100001100001'
      AND m.t_code IN ('0', '1', '2', '3', '4', '5', '6')
      AND m.te_ch1 = 'N'
      AND m.te_flag = 'Y'
      AND m.te_date1 <= SYS_DATETIME
ORDER BY m.te_date1 DESC
LIMIT 2;


SELECT m.t_code, m.tc_code,
       m.te_com, m.te_ch2, m.te_str2
FROM te m, td c
WHERE m.ta = '100001100001'
      AND c.ta = '100001100001'
      AND m.t_code = c.t_code
      AND m.t_code IN ('0', '1', '2', '3', '4', '5', '6')
      AND m.te_ch1 = 'N'
      AND m.te_flag = 'Y'
      AND c.td_flag1= 'N'
      AND m.te_date1 <= SYS_DATETIME
using index te_idx_3(+)
ORDER BY m.te_date1 DESC
LIMIT 2;



SELECT m.t_code, m.tc_code,
       m.te_com, m.te_ch2, m.te_str2
FROM te m, td c
WHERE m.ta = '100001100001'
      AND c.ta = '100001100001'
      AND m.t_code = c.t_code
      AND m.t_code = '0'
      AND m.te_ch1 = 'N'
      AND m.te_flag IN ('Y', 'N')
      AND c.td_flag1= 'N'
      AND m.te_date1 <= SYS_DATETIME
using index te_idx_3(+)
ORDER BY m.te_date1 DESC
LIMIT 2;




DROP TABLE ta;
DROP TABLE tb;
DROP TABLE tc;
DROP TABLE td;
DROP TABLE te;

DROP SERIAL ser;

COMMIT;


create table t (i int, j int, k int, l int);
create table u (a int, b int, c int, d int);
create table v (a int, b int, c int, d int);

create index i_t_i_j_k_d_l on t(i,j,k desc,l);
create index i_t_i_j_l on t(i,j,l);

insert into t values (1,1,1,1),(2,2,2,2),(3,3,3,3),(4,4,4,4),(5,5,5,5),(6,6,6,6),(7,7,7,7),(8,8,8,8);
insert into t values (1,1,1,1),(2,2,2,2),(3,3,3,3),(4,4,4,4),(5,5,5,5),(6,6,6,6),(7,7,7,7),(8,8,8,8);
insert into t values (1,1,1,1),(2,2,2,2),(3,3,3,3),(4,4,4,4),(5,5,5,5),(6,6,6,6),(7,7,7,7),(8,8,8,8);
insert into u values (1,1,1,1),(2,2,2,2),(3,3,3,3),(4,4,4,4),(5,5,5,5),(6,6,6,6),(7,7,7,7),(8,8,8,8);
insert into v values (1,1,1,1),(2,2,2,2),(3,3,3,3),(4,4,4,4),(5,5,5,5),(6,6,6,6),(7,7,7,7),(8,8,8,8);


-- not optimized
select * from t join u on t.i = u.a and t.j = 1 using index i_t_i_j_k_d_l(+) order by t.i limit 2;

-- optimized ok
select /*+ recompile */ * from t join u on t.j = u.a and t.i in (1,2) and t.j = 1 using index i_t_i_j_k_d_l(+) order by t.k desc limit 2;

-- the following are not optimized:

-- no constraining condition on t.j
select /*+ recompile */ * from t join u on t.j = u.a and t.i = 1  using index i_t_i_j_k_d_l(+) order by t.k desc limit 2;

-- wrong sort order
select /*+ recompile */ * from t join u on t.j = u.a and t.i = 1 and t.j in (1,2) using index i_t_i_j_k_d_l(+) order by t.k asc limit 2;

-- join cond on term  that is not in the index (using a different index)
select /*+ recompile */ * from t join u on t.k = u.a and t.i = 1 and t.j in (1,2) using index i_t_i_j_l(+) order by t.l asc limit 2;

-- join cond on term that comes after the sort column in the index used.
-- note this depends on the optimizer behavior: whether or not it places the sort table first or second
select /*+ recompile */ * from t join u on t.k = u.a and t.i = 1 and t.j in (1,2) and t.k = 3 using index i_t_i_j_k_d_l(+) order by t.l desc limit 2;

-- join condition on term that is exactly the RANGE one
select /*+ recompile */ * from t join u on t.j = u.a and t.i = 1 and t.j in (1,2) using index i_t_i_j_k_d_l(+) order by t.k desc limit 2;

-- three table join, only one equi class. must not optimize, there are no restrictions on t.i
select * from t,u,v where t.i = u.a and v.b = t.i and t.j in (1,2,3) and t.k  = 3 using index i_t_i_j_k_d_l(+) order by t.l limit 2;

-- three table join, only one equi class. must optimize ok, since there is also a condition on t.i
select * from t,u,v where t.i = u.a and v.b = t.i and t.j in (1,2,3) and t.k  = 3 and t.i = 3 using index i_t_i_j_k_d_l(+) order by t.l limit 2;

-- three table join, only one equi class. must not optimize, there are two range() operators, on t.j and also t.k
select * from t,u,v where t.i = u.a and v.b = t.i and t.j in (1,2,3) and t.k  in (3,4) and t.i = 3 using index i_t_i_j_k_d_l(+) order by t.l limit 2;


-- three table join, only one equi class. must not optimize, the range op is on t.i which is a join op.
-- actually the behaviour is unknown, depends on t's position in the query plan: if it is the first, then no optimization.
select * from t,u,v where t.i = u.a and v.b = t.i and t.j = 3 and t.k = 3 and t.i in (3,4) using index i_t_i_j_k_d_l(+) order by t.l limit 2;

-- will not optimize: there is no range() term, so CUBRID will skip order by and perform an index scan
select * from t,u,v where t.i = u.a and v.b = t.i and t.j = 3 and t.k = 3 and t.i = 3 using index i_t_i_j_k_d_l(+) order by t.l limit 2;


-- three table join, two equi classes. must optimize ok
select * from t,u,v where t.i = u.a and v.b = t.j and t.k in (1,2,3) and t.j  = 3 and t.i = 3 using index i_t_i_j_k_d_l(+) order by t.l limit 2;

-- three table join, two equi classes. no join because range is on a join column (t.j)
select * from t,u,v where t.i = u.a and v.b = t.j and t.j in (1,2,3) and t.k  = 3 and t.i = 3 using index i_t_i_j_k_d_l(+) order by t.l limit 2;



drop table t;
drop table u;
drop table v;


commit;
--+ holdcas off;
