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



-- rownum gets translated to keylimit sometimes
select /*+ recompile */ * from t1 where a>0 and c='011' and rownum=0 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and c='011' and rownum=-1 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and c='011' and rownum=-2 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and c='011' and rownum=1 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and c='011' and rownum=2 using index idx_t1_abc;

select /*+ recompile */ * from t1 where a>0 and 0 < rownum and rownum < 4 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and 0 <= rownum and rownum < 4 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and 0 <= rownum and rownum <= 4 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and 0 < rownum and rownum <= 4 using index idx_t1_abc;

select /*+ recompile */ * from t1 where a>0 and -1 < rownum and rownum < 4 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and -1 <= rownum and rownum < 4 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and -1 <= rownum and rownum <= 4 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and -1 < rownum and rownum <= 4 using index idx_t1_abc;

select /*+ recompile */ * from t1 where a>0 and -99 < rownum and rownum < 4 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and -99 <= rownum and rownum < 4 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and -99 <= rownum and rownum <= 4 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and -99 < rownum and rownum <= 4 using index idx_t1_abc;

select /*+ recompile */ * from t1 where a>0 and rownum between 1 and 5 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and rownum between 0 and 5 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and rownum between -1 and 5 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and rownum between -2 and 5 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and rownum between -3 and -2 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and rownum between -3 and -1 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and rownum between -3 and 0 using index idx_t1_abc;
select /*+ recompile */ * from t1 where a>0 and rownum between 1 and -3 using index idx_t1_abc;


select a,c from t1 where a>0 and c ='011' using index idx_t1_ac limit 1,3;



drop table t1;

