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

select /*+ recompile */
sum (v) over (partition by k1) as A1,
avg (v) over (partition by k1) as A2
from t
difference
select /*+ recompile */
sum (v) over (partition by k1+1) as A1,
avg (v) over (partition by k1+2) as A2
from t;

select /*+ recompile */
sum (v) over (partition by k1, k2) as A1,
avg (v) over (partition by k2, k1) as A2
from t
difference
select /*+ recompile */
sum (v) over (partition by k1+1, k2+1) as A1,
avg (v) over (partition by k2+2, k1+2) as A2
from t;

select /*+ recompile */
sum (v) over (partition by k1, k2) as A1,
avg (v) over (partition by k2) as A2
from t
difference
select /*+ recompile */
sum (v) over (partition by k1+1, k2+1) as A1,
avg (v) over (partition by k2+2) as A2
from t;

select /*+ recompile */
sum (v) over (partition by k1, k2 order by k3) as A1,
avg (v) over (partition by k2) as A2
from t
difference
select /*+ recompile */
sum (v) over (partition by k1+1, k2+1 order by k3+1) as A1,
avg (v) over (partition by k2+2) as A2
from t;

select /*+ recompile */
sum (v) over (partition by k1 order by k2) as A1,
avg (v) over (partition by k2, k1) as A2
from t
difference
select /*+ recompile */
sum (v) over (partition by k1+1 order by k2+2) as A1,
avg (v) over (partition by k2+2, k1+2) as A2
from t;

select /*+ recompile */
sum (v) over (partition by k1, k2 order by k3, k4) as A1,
avg (v) over (partition by k2 order by k1, k3, k4) as A2
from t
difference
select /*+ recompile */
sum (v) over (partition by k1+1, k2+1 order by k3+1, k4+1) as A1,
avg (v) over (partition by k2+2 order by k1+2, k3+2, k4+2) as A2
from t;

select /*+ recompile */
sum (v) over (partition by k1, k2, k3 order by k4) as A1,
avg (v) over (partition by k2, k3 order by k1, k4) as A2
from t
difference
select /*+ recompile */
sum (v) over (partition by k1+1, k2+1, k3+1 order by k4+1) as A1,
avg (v) over (partition by k2+2, k3+2 order by k1+2, k4+2) as A2
from t;


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
difference
select /*+ recompile */
sum (v)          over (partition by k1+1, k2+1 order by k3+1, k4+1) as A1,
avg (v)          over (partition by k1+2, k2+2 order by k3+2, k4+2) as A2,
stddev_samp (v)  over (partition by k1+3, k2+3 order by k3+3, k4+3) as A3,
stddev_pop (v)   over (partition by k1+4, k2+4 order by k3+4, k4+4) as A4,
var_samp (v)     over (partition by k1+5, k2+5 order by k3+5, k4+5) as A5,
var_pop (v)      over (partition by k1+6, k2+6 order by k3+6, k4+6) as A6,
min (v)          over (partition by k1+7, k2+7 order by k3+7, k4+7) as A7,
max (v)          over (partition by k1+8, k2+8 order by k3+8, k4+8) as A8,
lead (v)         over () as A9
from t;

select /*+ recompile */
sum (v)          over (order by k1) as A1,
avg (v)          over (order by k1, k2) as A2,
stddev_samp (v)  over (order by k1, k2, k3) as A3,
stddev_pop (v)   over (order by k1, k2, k3, k4) as A4,
var_samp (v)     over (partition by k1) as A5,
var_pop (v)      over (partition by k2, k1) as A6,
min (v)          over (partition by k3, k2, k1) as A7,
max (v)          over (partition by k3, k2, k1, k4) as A8,
lead (v)         over (order by k1,v) as A9
from t
difference
select /*+ recompile */
sum (v)          over (order by k1+1) as A1,
avg (v)          over (order by k1+2, k2+2) as A2,
stddev_samp (v)  over (order by k1+3, k2+3, k3+3) as A3,
stddev_pop (v)   over (order by k1+4, k2+4, k3+4, k4+4) as A4,
var_samp (v)     over (partition by k1+5) as A5,
var_pop (v)      over (partition by k2+8, k1+8) as A6,
min (v)          over (partition by k3+6, k2+6, k1+6) as A7,
max (v)          over (partition by k3+7, k2+7, k1+7, k4+7) as A8,
lead (v)         over (order by k1+1,v) as A9
from t;

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
difference
select /*+ recompile */
sum (v)          over (partition by k1+1) as A1,
avg (v)          over (partition by k1+2, k2+2) as A2,
stddev_samp (v)  over (partition by k1+3, k2+3, k3+3) as A3,
stddev_pop (v)   over (partition by k1+4, k2+4, k3+4, k4+4) as A4,
var_samp (v)     over (partition by k1+5 order by k2+5) as A5,
var_pop (v)      over (partition by k1+6, k2+6 order by k3+6) as A6,
min (v)          over (partition by k1+7, k2+7, k3+7 order by k4+7) as A7,
max (v)          over (partition by k1+8, k2+8 order by k3+8, k4+8) as A8,
lead (v)         over () as A9
from t;

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
difference
select /*+ recompile */
sum (v)          over (partition by k1+1) as A1,
avg (v)          over (partition by k1+2, k2+2) as A2,
stddev_samp (v)  over (partition by k1+3, k2+3, k3+3) as A3,
stddev_pop (v)   over (partition by k4+4, k3+4, k2+4, k1+4) as A4,
var_samp (v)     over (partition by k1+5 order by k2+5) as A5,
var_pop (v)      over (partition by k2+6, k1+6 order by k3+6) as A6,
min (v)          over (partition by k3+7, k2+7, k1+7 order by k4+7) as A7,
max (v)          over (partition by k2+8, k1+8 order by k3+8, k4+8) as A8,
lead (v)         over () as A9
from t;

select 'two runs';
select /*+ recompile */
sum (v)          over (partition by k1) as A1,
avg (v)          over (partition by k1, k2) as A2,
stddev_samp (v)  over (partition by k1, k2, k3) as A3,
stddev_pop (v)   over (partition by k4, k3 order by k2, k1) as A4,
var_samp (v)     over (partition by k1 order by k2) as A5,
var_pop (v)      over (partition by k2, k1 order by k3) as A6,
min (v)          over (partition by k3, k4, k2 order by k1) as A7,
max (v)          over (partition by k2, k1 order by k3, k4) as A8
from t
difference
select /*+ recompile */
sum (v)          over (partition by k1+1) as A1,
avg (v)          over (partition by k1+2, k2+2) as A2,
stddev_samp (v)  over (partition by k1+3, k2+3, k3+3) as A3,
stddev_pop (v)   over (partition by k4+4, k3+4 order by k2+4, k1+4) as A4,
var_samp (v)     over (partition by k1+5 order by k2+5) as A5,
var_pop (v)      over (partition by k2+6, k1+6 order by k3+6) as A6,
min (v)          over (partition by k3+7, k4+7, k2+7 order by k1+7) as A7,
max (v)          over (partition by k2+8, k1+8 order by k3+8, k4+8) as A8
from t;

select /*+ recompile */
sum (v)          over (partition by k1) as A1,
avg (v)          over (partition by k1, k2) as A2,
stddev_samp (v)  over (partition by k1, k2, k3) as A3,
stddev_pop (v)   over (partition by k4, k3 order by k2, k1) as A4,
var_samp (v)     over (partition by k1 order by k2) as A5,
var_pop (v)      over (partition by k2, k1 order by k3) as A6,
min (v)          over (partition by k3, k4, k2 order by k1) as A7,
max (v)          over (partition by k3, k4 order by k2, k1) as A8
from t
difference
select /*+ recompile */
sum (v)          over (partition by k1+1) as A1,
avg (v)          over (partition by k1+2, k2+2) as A2,
stddev_samp (v)  over (partition by k1+3, k2+3, k3+3) as A3,
stddev_pop (v)   over (partition by k4+4, k3+4 order by k2+4, k1+4) as A4,
var_samp (v)     over (partition by k1+5 order by k2+5) as A5,
var_pop (v)      over (partition by k2+6, k1+6 order by k3+6) as A6,
min (v)          over (partition by k3+7, k4+7, k2+7 order by k1+7) as A7,
max (v)          over (partition by k3+8, k4+8 order by k2+8, k1+8) as A8
from t;

select 'three runs';
select /*+ recompile */
sum (v)          over (partition by k1, k2 order by k3, k4) as A1,
avg (v)          over (partition by k1, k2 order by k3, k4) as A2,
stddev_samp (v)  over (partition by k3, k4 order by k1, k2) as A3,
stddev_pop (v)   over (partition by k3, k4 order by k1, k2) as A4,
var_samp (v)     over (partition by k4, k3 order by k1, k2) as A5,
var_pop (v)      over (partition by k4, k3 order by k2, k1) as A6,
min (v)          over (partition by k3, k4 order by k2, k1) as A7,
max (v)          over (partition by k3, k4 order by k2, k1) as A8
from t
difference
select /*+ recompile */
sum (v)          over (partition by k1+1, k2+1 order by k3+1, k4+1) as A1,
avg (v)          over (partition by k1+2, k2+2 order by k3+2, k4+2) as A2,
stddev_samp (v)  over (partition by k3+3, k4+3 order by k1+3, k2+3) as A3,
stddev_pop (v)   over (partition by k3+4, k4+4 order by k1+4, k2+4) as A4,
var_samp (v)     over (partition by k4+5, k3+5 order by k1+5, k2+5) as A5,
var_pop (v)      over (partition by k4+6, k3+6 order by k2+6, k1+6) as A6,
min (v)          over (partition by k3+7, k4+7 order by k2+7, k1+7) as A7,
max (v)          over (partition by k3+8, k4+8 order by k2+8, k1+8) as A8
from t;

drop t;
