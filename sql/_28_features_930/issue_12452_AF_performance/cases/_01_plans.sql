drop table if exists t;
create table t (k1 int, k2 int, k3 int, k4 int, v int);
insert into t values
(1, 1, 1, 1, 1),
(1, 1, 1, 2, 2),
(1, 1, 1, 3, 3),
(1, 1, 2, 1, 4),
(1, 1, 2, 2, 5),
(1, 1, 3, 1, 6),
(1, 1, 3, 2, 7),
(1, 1, 3, 3, 8),
(1, 2, 1, 1, 9),
(1, 2, 1, 2, 10),
(1, 2, 2, 1, 11),
(1, 2, 2, 2, 12),
(1, 2, 2, 3, 13),
(1, 2, 3, 1, 14),
(1, 3, 1, 1, 15),
(1, 3, 2, 1, 16),
(1, 3, 3, 1, 17),
(1, 3, 3, 2, 18),
(1, 3, 3, 3, 19),
(1, 4, 1, 1, 20);

select 'compatible';
-- compatible windows
select /*+ recompile */
sum (v) over () as A1,
avg (v) over () as A2
from t
order by 1, 2;

select /*+ recompile */
sum (v) over (partition by k1) as A1,
avg (v) over (partition by k1) as A2
from t
order by 1, 2;

select /*+ recompile */
sum (v) over (partition by k1, k2) as A1,
avg (v) over (partition by k2, k1) as A2
from t
order by 1, 2;

select /*+ recompile */
sum (v) over (partition by k1, k2) as A1,
avg (v) over (partition by k2) as A2
from t
order by 1, 2;

select /*+ recompile */
sum (v) over (partition by k1, k2 order by k3) as A1,
avg (v) over (partition by k2) as A2
from t
order by 1, 2;

select /*+ recompile */
sum (v) over (partition by k1 order by k2) as A1,
avg (v) over (partition by k2, k1) as A2
from t
order by 1, 2;

select /*+ recompile */
sum (v) over (partition by k1, k2 order by k3, k4) as A1,
avg (v) over (partition by k2 order by k1, k3, k4) as A2
from t
order by 1, 2;

select /*+ recompile */
sum (v) over (partition by k1, k2, k3 order by k4) as A1,
avg (v) over (partition by k2, k3 order by k1, k4) as A2
from t
order by 1, 2;

select /*+ recompile */
sum (v) over (partition by k1, k2, k3 order by k4) as A1,
avg (v) over () as A2
from t
order by 1, 2;

select 'incompatible';
-- incompatible windows
select /*+ recompile */
sum (v) over (partition by k1 order by k2) as A1,
avg (v) over (partition by k3 order by k4) as A2
from t
order by 1, 2;

select /*+ recompile */
sum (v) over (partition by k1, k3) as A1,
avg (v) over (partition by k1, k2) as A2
from t
order by 1, 2;

select /*+ recompile */
sum (v) over (partition by k1, k2, k3) as A1,
avg (v) over (partition by k1, k2, k4) as A2
from t
order by 1, 2;

select /*+ recompile */
sum (v) over (partition by k1, k2 order by k3) as A1,
avg (v) over (partition by k1 order by k3, k2) as A2
from t
order by 1, 2;

select /*+ recompile */
sum (v) over (partition by k2, k1 order by k3) as A1,
avg (v) over (partition by k1 order by k3, k2) as A2
from t
order by 1, 2;

select 'one run';
select /*+ recompile */
sum (v)          over (partition by k1, k2 order by k3, k4) as A1,
avg (v)          over (partition by k1, k2 order by k3, k4) as A2,
stddev_samp (v)  over (partition by k1, k2 order by k3, k4) as A3,
stddev_pop (v)   over (partition by k1, k2 order by k3, k4) as A4,
var_samp (v)     over (partition by k1, k2 order by k3, k4) as A5,
var_pop (v)      over (partition by k1, k2 order by k3, k4) as A6,
min (v)          over (partition by k1, k2 order by k3, k4) as A7,
max (v)          over (partition by k1, k2 order by k3, k4) as A8,
lead (v)         over () as A9
from t
order by 1, 2, 3, 4, 5, 6, 7, 8, 9;

select /*+ recompile */
sum (v)          over (order by k1) as A1,
avg (v)          over (order by k1, k2) as A2,
stddev_samp (v)  over (order by k1, k2, k3) as A3,
stddev_pop (v)   over (order by k1, k2, k3, k4) as A4,
var_samp (v)     over (partition by k1) as A5,
var_pop (v)      over (partition by k2, k1) as A6,
min (v)          over (partition by k3, k2, k1) as A7,
max (v)          over (partition by k3, k2, k1, k4) as A8,
lead (v)         over () as A9
from t
order by 1, 2, 3, 4, 5, 6, 7, 8, 9;

select /*+ recompile */
sum (v)          over (partition by k1) as A1,
avg (v)          over (partition by k1, k2) as A2,
stddev_samp (v)  over (partition by k1, k2, k3) as A3,
stddev_pop (v)   over (partition by k1, k2, k3, k4) as A4,
var_samp (v)     over (partition by k1 order by k2) as A5,
var_pop (v)      over (partition by k1, k2 order by k3) as A6,
min (v)          over (partition by k1, k2, k3 order by k4) as A7,
max (v)          over (partition by k1, k2 order by k3, k4) as A8,
lead (v)         over () as A9
from t
order by 1, 2, 3, 4, 5, 6, 7, 8, 9;

select /*+ recompile */
sum (v)          over (partition by k1) as A1,
avg (v)          over (partition by k1, k2) as A2,
stddev_samp (v)  over (partition by k1, k2, k3) as A3,
stddev_pop (v)   over (partition by k4, k3, k2, k1) as A4,
var_samp (v)     over (partition by k1 order by k2) as A5,
var_pop (v)      over (partition by k2, k1 order by k3) as A6,
min (v)          over (partition by k3, k2, k1 order by k4) as A7,
max (v)          over (partition by k2, k1 order by k3, k4) as A8,
lead (v)         over () as A9
from t
order by 1, 2, 3, 4, 5, 6, 7, 8, 9;

select 'two runs';
select /*+ recompile */
sum (v)          over (partition by k1) as A1,
avg (v)          over (partition by k1, k2) as A2,
stddev_samp (v)  over (partition by k1, k2, k3) as A3,
stddev_pop (v)   over (partition by k4, k3 order by k2, k1) as A4,
var_samp (v)     over (partition by k1 order by k2) as A5,
var_pop (v)      over (partition by k2, k1 order by k3) as A6,
min (v)          over (partition by k3, k4, k2 order by k1) as A7,
max (v)          over (partition by k2, k1 order by k3, k4) as A8,
lead (v)         over () as A9
from t
order by 1, 2, 3, 4, 5, 6, 7, 8, 9;

select /*+ recompile */
sum (v)          over (partition by k1) as A1,
avg (v)          over (partition by k1, k2) as A2,
stddev_samp (v)  over (partition by k1, k2, k3) as A3,
stddev_pop (v)   over (partition by k4, k3 order by k2, k1) as A4,
var_samp (v)     over (partition by k1 order by k2) as A5,
var_pop (v)      over (partition by k2, k1 order by k3) as A6,
min (v)          over (partition by k3, k4, k2 order by k1) as A7,
max (v)          over (partition by k3, k4 order by k2, k1) as A8,
lead (v)         over () as A9
from t
order by 1, 2, 3, 4, 5, 6, 7, 8, 9;

select 'three runs';
select /*+ recompile */
sum (v)          over (partition by k1, k2 order by k3, k4) as A1,
avg (v)          over (partition by k1, k2 order by k3, k4) as A2,
stddev_samp (v)  over (partition by k3, k4 order by k1, k2) as A3,
stddev_pop (v)   over (partition by k3, k4 order by k1, k2) as A4,
var_samp (v)     over (partition by k4, k3 order by k1, k2) as A5,
var_pop (v)      over (partition by k4, k3 order by k2, k1) as A6,
min (v)          over (partition by k3, k4 order by k2, k1) as A7,
max (v)          over (partition by k3, k4 order by k2, k1) as A8,
lead (v)         over () as A9
from t
order by 1, 2, 3, 4, 5, 6, 7, 8, 9;

drop t;
