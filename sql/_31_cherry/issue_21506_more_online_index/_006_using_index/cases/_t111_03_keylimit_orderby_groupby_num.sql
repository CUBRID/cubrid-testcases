--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE t1 (
   a  INT NOT NULL,
   b  VARCHAR(40) NOT NULL,
   c  CHAR(3)
  );
CREATE UNIQUE INDEX idx_t1_ac ON t1(a,c) with online;
CREATE INDEX idx_t1_abc ON t1(a,b,c) with online;

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
select /*+ RECOMPILE */ a,c from t1 using index idx_t1_ac(+) keylimit 2,4 order by a for ORDERBY_NUM()<=2;

--TEST:
select /*+ RECOMPILE */ c,count(*) from t1 where a>0 and c is not null group by c having GROUPBY_NUM() between 2 and 100 using index idx_t1_ac keylimit 5,7;

drop table t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
