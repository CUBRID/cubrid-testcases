--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE t1 (
   a  INT NOT NULL,
   b  VARCHAR(40) NOT NULL,
   c  CHAR(3)
  );
CREATE INDEX "keylimit" ON t1(a,c);

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

--TEST: check remained value
select /*+ RECOMPILE */ a,b,c from t1 order by a asc;

drop table t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
