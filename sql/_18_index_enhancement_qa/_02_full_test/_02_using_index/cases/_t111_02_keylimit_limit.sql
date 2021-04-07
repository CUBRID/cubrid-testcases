--+ holdcas on;
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

--TEST:  what would rownum begain with? 5 or 1? 
select rownum, a,c from t1 where a>0 and c ='011' using index idx_t1_ac keylimit 5,10 limit 1,3;

--TEST:  what would rownum begain with? 5 or 1? 
select rownum, a,c from t1 where a>0 and c ='011' using index idx_t1_ac(+) keylimit 5,10 limit 1,3;

--TEST:  
select rownum, t1_a.a,t1_a.c from t1 t1_a , t1 t1_b where t1_a.a>0 and t1_a.c='011' and t1_b.a>0 and t1_b.c ='011' using index t1_a.idx_t1_ac(+) keylimit 5,10, t1_b.idx_t1_ac(+) keylimit 5,10  limit 1,3;

--TEST:  what would rownum begain with? 5 or 1? 
select rownum, a,c from t1 where a>0 and c ='011' using index idx_t1_ac(+) keylimit 5,10, idx_t1_ac(+) keylimit 1,5;


--TEST: 
delete from t1 where a>0 and c='011' using index idx_t1_ac keylimit 2,2 limit 1,1;

--TEST:
delete from t1 where a>0 and c='085' using index idx_t1_ac kEyLiMiT 2,4 limit 1,1;

--TEST: 
delete from t1 where a>0 and c='085' using index idx_t1_ac kEyLiMiT 2,4 limit 1,2;

--TEST: check remained value
select /*+ RECOMPILE */ a,b,c from t1 order by 1,2,3;

drop table t1;
commit;
--+ holdcas off;
