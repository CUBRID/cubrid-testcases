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

--TEST:
update t1 set a=a+10 where a>0 and c='086' using index idx_t1_ac kEyLiMiT 2,4;

--TEST: check remained value
select /*+ RECOMPILE */ a,b,c from t1 order by a,b,c;

drop table t1;
commit;
--+ holdcas off;
