-- set up table
--+ holdcas on;

create table t (i int, c char(10), j int);
insert into t values (1, 'a', 1);
insert into t values (1, 'a', 2);
insert into t values (1, 'a', 3);
insert into t values (1, 'b', 1);
insert into t values (1, 'b', 2);
insert into t values (2, 'a', 1);
insert into t values (2, 'a', 2);
insert into t values (2, 'b', 1);

-- with rollup, no aggregate
select /*+ recompile */ i, c, j from t group by i, c, j with rollup;

-- with rollup, no aggregate, having (attr)
select /*+ recompile */ i, c, j from t group by i, c, j with rollup having c is not null;

-- with rollup, no aggregate, having (attr 2)
select /*+ recompile */ i, c, j from t group by i, c, j with rollup having j > 1;

-- with rollup, no aggregate, having (aggr) *
select /*+ recompile */ i, c, max(j) from t group by i, c with rollup having max(j) > 2;

-- with rollup, aggregate
select /*+ recompile */ i, c, j, count(j) from t group by i, c, j with rollup;

-- with rollup, aggregate
select /*+ recompile */ i, c, count(j) from t group by i, c with rollup;

-- with rollup, aggregate, having (attr)
select /*+ recompile */ i, c, count(j) from t group by i, c with rollup having c is not null;

-- with rollup, aggregate, having (attr 2)
select /*+ recompile */ i, c, count(j) from t group by i, c with rollup having c > 'a';

-- with rollup, aggregate, having (aggr) *
select /*+ recompile */ i, c, count(j) from t group by i, c with rollup having max(j) > 2;

-- with rollup, groupby_num (error)
select i, c, count(j) from t group by i, c with rollup having groupby_num() < 2 or groupby_num() > 3;

-- cleanup
drop t;
--+ holdcas off;
commit;

