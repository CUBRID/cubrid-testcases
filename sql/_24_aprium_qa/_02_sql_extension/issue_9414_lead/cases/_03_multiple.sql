-- scenario
create table t (p int, o int, v int, d varchar(20), j int);
insert into t values (1, 1, 1,   '-1',  1);
insert into t values (1, 2, 2,   '-2',  2);
insert into t values (1, 3, 3,   '-3',  1);
insert into t values (1, 4, 4,   '-4',  0);
insert into t values (1, 5, 5,   '-5',  -1);
insert into t values (2, 6, 6,   '-6',  0);
insert into t values (2, 7, 7,   '-7',  1);
insert into t values (2, 8, 8,   '-8',  1000);
insert into t values (2, 9, 9,   '-9',  -1);
insert into t values (2, 10, 10, '-10', 2);
insert into t values (2, 11, 11, '-11', 1);
insert into t values (1, 12, 12, '-12', 1);
insert into t values (1, 13, 13, '-13', 0);
insert into t values (1, 14, 14, '-14', 1);

-- tests
select
  v, j, d,
  lead (v, j, d) over (order by o) as o,
  lead (v, j, d) over (partition by p order by o) as p_o,
  lead (v, j, d) over (partition by p order by o desc) as p_od,
  lead (v, j, d) over (order by p asc, o desc) as paod,
  lag  (v, j, d) over (order by o) as o2,
  lag  (v, j, d) over (partition by p order by o) as p_o2,
  lag  (v, j, d) over (partition by p order by o desc) as p_od2,
  lag  (v, j, d) over (order by p asc, o desc) as paod2
from t;

-- cleanup
drop table t;
