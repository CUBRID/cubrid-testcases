CREATE TABLE t1 (a  INT NOT NULL, b  VARCHAR(40) NOT NULL, c  CHAR(3));

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

select /*+ RECOMPILE */ a, groupby_num() from t1 where a>0  group by a;
select /*+ RECOMPILE */ a, groupby_num() from t1 where a>0  group by a desc;
select /*+ RECOMPILE */ a, groupby_num() from t1 where a>0 group by a having groupby_num() >= 2 and groupby_num() <= 7;
select /*+ RECOMPILE */ a, groupby_num() from t1 where a>0 group by a desc having groupby_num() >= 2 and groupby_num() <= 7;

DROP TABLE t1;
