set optimization level 513;
--QA_effort_01
drop table if exists t1, t2, t3; 
create table t1
(
     t1_id               INTEGER NOT NULL,
     njdh              CHARACTER VARYING(14) NOT NULL,
     PRIMARY KEY pk_t1 (t1_id)
);
 
create table t2
(
     njdh              CHARACTER VARYING(14) NOT NULL,
     t1_id               INTEGER,
     PRIMARY KEY pk_t2 (njdh)
);
 
create table t3
(
     t3_id                INTEGER NOT NULL,
     t1_id               INTEGER NOT NULL,
     tzph_nd         CHARACTER VARYING(20),
     jeu_nd               CHARACTER VARYING(20),
     PRIMARY KEY pk_t3 (t3_id)
);
CREATE INDEX i_cam_order_01 ON t3 (t1_id, tzph_nd);
 
SELECT /*+ recompile ORDERED */ count(*) FROM t1 JOIN t2 ON t2.njdh= t1.njdh JOIN t3 ON t3.t1_id = t1.t1_id AND t3.tzph_nd = 'MAIN';
drop table t1,t2,t3;

--QA_effort_02
--refer to bug_bts_7547_2.sql 

--QA_effort_03
--refer to scenario/shell/_06_issues/_15_1h/bug_bts_7547/cases

--QA_effort_04
drop table if exists LODDZ, LODDZ_TIMESTAMP, LODDZUEJOP, PWPHE;
 
create table LODDZ (pwphemj int, mpwphemj int, mpwpheid int, mminkmwvh int, uejopid int);
create table LODDZ_TIMESTAMP (lsjumj int, mlsjumj int, swatYiaitDwth date);
create table LODDZUEJOP (pwphemj int, uejopid int, jphmzm int);
create table PWPHE (pwphemj int, lsjnkzm int, ivwuh int, pwphemwvh int);
create index ink1_paper on PWPHE (pwphemj);
 
  SELECT /*+ recompile ordered */ DISTINCT bb.pwphemj, bb.mpwphemj, bb.mpwpheid, p.ivwuh,
   p.pwphemwvh, bb.mminkmwvh, p.ivwuh, bt.swatYiaitDwth
  FROM
   (
   SELECT /*+ recompile */  DISTINCT pwphemj, mpwphemj, mpwpheid, mminkmwvh, uejopid
   FROM LODDZ b
   WHERE b.pwphemj IN
     (
          1, 2
     )
   AND  b.mpwphemj > 0 
   AND  b.mpwphemj <> 9   
   ) bb
   INNER JOIN LODDZ_TIMESTAMP bt 
    ON bt.lsjumj = bb.pwphemj
    AND bt.mlsjumj = bb.mpwphemj
    AND bt.swatYiaitDwth > DATE_ADD(CURRENT_DATETIME, INTERVAL -1 MONTH) 
   INNER JOIN LODDZUEJOP bg
    ON bg.pwphemj = bb.pwphemj 
    AND bg.uejopid = bb.uejopid
    AND bg.jphmzm = 1 
   INNER JOIN PWPHE p
    ON p.pwphemj = bb.mpwphemj 
    AND (p.lsjnkzm is NULL OR p.lsjnkzm NOT IN (1,3))
  ORDER BY bt.swatYiaitDwth DESC ;
drop table LODDZ, LODDZ_TIMESTAMP, LODDZUEJOP, PWPHE;

--QA Effort 05
drop table if exists t;
drop table if exists u;
drop table if exists v;
create table t (i int, j int);
create table u (i int, j int);
create table v (i int, j int);
 
insert into t values (1, 1), (2, 2), (3, 3);
insert into u values (1, 1), (2, 2), (4, 4);
insert into v values (1, 1), (3, 3), (5, 5);
 
drop view if exists yt;
create view yt as select * from t where i > 0;
create index idx1 on t (i, j);
 
select /*+ recompile */ *
from    yt,
        u
        right join v on u.i = v.i
order by yt.i, v.i;
drop view yt;
drop table t,u,v;

--QA Effort 06
drop table if exists fjj;
 
create table fjj (i int, k int);
create index idx1 on fjj (k);
 
SELECT /*+ recompile */ count(*)
FROM    fjj a
        left outer join fjj b on a.i=b.i
        right outer join fjj c on b.i=c.i,
        fjj d
where   a.k=d.k;
drop table fjj;

