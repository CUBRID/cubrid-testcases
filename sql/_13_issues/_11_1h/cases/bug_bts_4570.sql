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

select /*+ RECOMPILE */ a,b,c from t1 where a<100 and c='086' using index idx_t1_ac(+) keylimit -1;
select /*+ RECOMPILE */ a,b,c from t1 where a<100 and c='086' using index idx_t1_ac(+) keylimit 1999999999;
select /*+ RECOMPILE */ a,b,c from t1 where a<100 and c='086' using index idx_t1_ac(+) keylimit 2000000000;

drop table t1;

---------------------------
-- CUBRIDSUS-4796: when converting to keylimit there should be no error

create table t (id int, a varchar(20));
create index i_t_all on t(id,a);
insert into t values (23, 'Vlad'), (19,'Andra');

select /*+ recompile */ id,a from t where id> 0 and rownum<10000000000;
select /*+ recompile */ id,a from t where id> 0 and rownum<=10000000000;

select /*+ recompile */ id,a from t where id> 0 and rownum<10000000000 and rownum > 5000000000;

drop table t;





-- CUBRIDSUS-4570: keylimit was limited to 2 billion. not anymore!

CREATE TABLE t1 (
a INT NOT NULL,
b VARCHAR(40) NOT NULL,
c CHAR(3)
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

select /*+ RECOMPILE */ a,b,c from t1 where a<100 and c='086' using index idx_t1_ac keylimit 1999999999;
select /*+ RECOMPILE */ a,b,c from t1 where a<100 and c='086' using index idx_t1_ac keylimit 2000000000;
select /*+ RECOMPILE */ a,b,c from t1 where a<100 and c='086' using index idx_t1_ac keylimit 5000000000;
select /*+ RECOMPILE */ a,b,c from t1 where a<100 and c='086' using index idx_t1_ac keylimit 5000000000,5000000000;


-- using use_orderby_sort_limit optimization
set system parameters 'use_orderby_sort_limit=yes';
select b from t1 order by b desc limit 3;
select b from t1 order by b desc limit 5000000000;


drop t1;

commit;

--+ holdcas off;

