create table t (i int);

insert into t values (1);
insert into t values (2);
insert into t values (3);
insert into t values (4);
insert into t values (5);
insert into t values (6);

create index i_t_i on t(i);
select /*+ recompile */ t.i,rownum  from t where i>0  using index i_t_i keylimit 1,3 order by i limit 2,4;
select /*+ recompile */ t.i  from t order by i limit 1,2;
drop table t;

CREATE TABLE t1 (

a  INT NOT NULL,
b  VARCHAR(40) NOT NULL,

c  CHAR(3)
);

CREATE INDEX "idx_t1_ac" ON t1(a,c);


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
 

select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc limit 1;

select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc limit 0,1;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num()<3;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 1 and 2;

select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 0,0 order by a asc for orderby_num() between 4 and 2;

drop table t1;

