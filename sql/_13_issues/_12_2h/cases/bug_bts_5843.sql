create table t (a int);
create index t_idx_5843 on t(a);
insert into t values (1),(2),(3),(4),(5);

$int, $2
select a, '=2' as op from t where a  = ? order by a;
select a, '=2' as op from t where a  = 2 order by a;

$int, $2
select a, '<2' as op from t where a  < ? order by a;
select a, '<2' as op from t where a  < 2 order by a;

$int, $2
select a, '>2' as op from t where a  > ? order by a;
select a, '>2' as op from t where a  > 2 order by a;

$int, $2
select a, '>=2' as op from t where a  >= ? order by a;
select a, '>=2' as op from t where a  >= 2 order by a;

$numeric, $2.5
select a, '=2.5' as op from t where a  = ? order by a;
select a, '=2.5' as op from t where a  = 2.5 order by a;

$numeric, $2.5
select a, '<2.5' as op from t where a  < ? order by a;
select a, '<2.5' as op from t where a  < 2.5 order by a;

$numeric, $2.5
select a, '>2.5' as op from t where a  > ? order by a;
select a, '>2.5' as op from t where a  > 2.5 order by a;

$numeric, $2.5
select a, '>=2.5' as op from t where a  >= ? order by a;
select a, '>=2.5' as op from t where a  >= 2.5 order by a;

$float, $2.5f
select a, '=2.5f' as op from t where a  = ? order by a;
select a, '=2.5f' as op from t where a  = 2.5f order by a;

$float, $2.5f
select a, '<2.5f' as op from t where a  < ? order by a;
select a, '<2.5f' as op from t where a  < 2.5f order by a;

$float, $2.5f
select a, '>2.5f' as op from t where a  > ? order by a;
select a, '>2.5f' as op from t where a  > 2.5f order by a;

$float, $2.5f
select a, '>=2.5f' as op from t where a  >= ? order by a;
select a, '>=2.5f' as op from t where a  >= 2.5f order by a;

$double, $2.5
select a, '=25e-1' as op from t where a  = ? order by a;
select a, '=25e-1' as op from t where a  = 25e-1 order by a;

$double, $2.5
select a, '<25e-1' as op from t where a  < ? order by a;
select a, '<25e-1' as op from t where a  < 25e-1 order by a;

$double, $2.5
select a, '>25e-1' as op from t where a  > ? order by a;
select a, '>25e-1' as op from t where a  > 25e-1 order by a;

$double, $2.5
select a, '>=25e-1' as op from t where a  >= ? order by a;
select a, '>=25e-1' as op from t where a  >= 25e-1 order by a;

$varchar, $2
select a, '=2' as op from t where a  = ? order by a;
select a, '=2' as op from t where a  = '2' order by a;

$varchar, $2
select a, '<2' as op from t where a  < ? order by a;
select a, '<2' as op from t where a  < '2' order by a;

$varchar, $2
select a, '>2' as op from t where a  > ? order by a;
select a, '>2' as op from t where a  > '2' order by a;

$varchar, $2
select a, '>=2' as op from t where a  >= ? order by a;
select a, '>=2' as op from t where a  >= '2' order by a;

$varchar, $2.5
select a, '=2.5' as op from t where a  = ? order by a;
select a, '=2.5' as op from t where a  = '2.5' order by a;

$varchar, $2.5
select a, '<2.5' as op from t where a  < ? order by a;
select a, '<2.5' as op from t where a  < '2.5' order by a;

$varchar, $2.5
select a, '>2.5' as op from t where a  > ? order by a;
select a, '>2.5' as op from t where a  > '2.5' order by a;

$varchar, $2.5
select a, '>=2.5' as op from t where a  >= ? order by a;
select a, '>=2.5' as op from t where a  >= '2.5' order by a;

drop table t;
