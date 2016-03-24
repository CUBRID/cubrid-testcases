--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
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

create serial seq_t1_a
start with 100
increment by 1
minvalue 100
maxvalue 10000000000000000000000000000000000000
nocycle;

--TEST:  
select /*+ RECOMPILE */ seq_t1_a.nextval,a,b,c from t1 where a>0 and c is not null using index idx_t1_ac(+) keylimit 3,3;

--TEST:  
update t1 set a=seq_t1_a.nextval where a>0 and c is not null using index idx_t1_ac keylimit 3,3;

select /*+ RECOMPILE */ * from t1 order by a,b,c;
drop table t1;
drop serial seq_t1_a;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
