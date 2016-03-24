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


select /*+ recompile */ * from t1 where a>0 using index idx_t1_abc(+) keylimit 2,5;
select /*+ recompile */ * from t1 where a>0 using index idx_t1_abc(+) keylimit 1,5;
select /*+ recompile */ * from t1 where a>0 using index idx_t1_abc(+) keylimit 0,5;
select /*+ recompile */ * from t1 where a>0 using index idx_t1_abc(+) keylimit 5;
select /*+ recompile */ * from t1 where a>0 using index idx_t1_abc(+) keylimit -1,5;
select /*+ recompile */ * from t1 where a>0 using index idx_t1_abc(+) keylimit 3,-1;
select /*+ recompile */ * from t1 where a>0 using index idx_t1_abc(+) keylimit 3,0;
select /*+ recompile */ * from t1 where a>0 using index idx_t1_abc(+) keylimit 3,1;


-- CUBRIDSUS-4546
select /*+ RECOMPILE */ a from t1 where a>0 group by a asc having groupby_num()<100 using index idx_t1_abc keylimit 5,10;


-- no result, there are only 5 matching rows
select a,c from t1 where a>0 and c ='011' using index idx_t1_ac keylimit 5,10;

-- last 2 results
select a,c from t1 where a>0 and c ='011' using index idx_t1_ac keylimit 3,2;

-- -> keylimit 2,2 (low = max(lows), cnt = min(cnts));
select a,c from t1 where a>0 and c ='011' using index idx_t1_ac keylimit 2,10 limit 1,2;

select a,c from t1 where a>0 and c ='011' using index idx_t1_ac limit 1,3;



drop table t1;

