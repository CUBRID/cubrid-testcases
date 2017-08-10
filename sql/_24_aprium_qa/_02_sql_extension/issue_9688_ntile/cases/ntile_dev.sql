drop table if exists t_ntile;

create table t_ntile (a int, b int);
insert into t_ntile values(1,2),(10,1),(2,5),(11,19),(3,7),(12,11),(20,21),(15,14),(10,5),(null,5),(10,null),(null,null);

select ntile(NULL) over () from t_ntile order by 1;
select ntile(0) over () from t_ntile order by 1;
select ntile(4) over () from t_ntile order by 1;
select ntile((select count(*) from t_ntile)) over () from t_ntile order by 1;
select ntile(1+(select count(*) from t_ntile)) over () from t_ntile order by 1;

select ntile(0) over (order by a) from t_ntile order by 1;
select ntile(4) over (order by a) from t_ntile order by 1;
select ntile(10) over (order by a) from t_ntile order by 1;
select ntile((select count(*) from t_ntile)) over (order by a) from t_ntile order by 1;
select ntile(1+(select count(*) from t_ntile)) over (order by a) from t_ntile order by 1;
select ntile(4) over (order by NULL) from t_ntile order by 1;
select ntile(5) over (order by b desc) from t_ntile order by 1;
select ntile(5) over (order by a, b desc) from t_ntile order by 1;

select ntile(0) over (partition by a) from t_ntile order by 1;
select ntile(6) over (partition by a) from t_ntile order by 1;
select ntile((select count(*) from t_ntile)) over (partition by a) from t_ntile order by 1;
select ntile(2+(select count(*) from t_ntile)) over (partition by a) from t_ntile order by 1;
select ntile(4) over (partition by b) from t_ntile order by 1;

select ntile(4) over (partition by a,b) from t_ntile order by 1;
select ntile(4) over (partition by (a>10),(b<10)) from t_ntile order by 1;
select ntile(4) over (partition by (a>10),(b<5)) from t_ntile order by 1;
select ntile(4) over (partition by NULL) from t_ntile order by 1;
select ntile(5) over (partition by (a>10) order by b) from t_ntile order by 1;
select ntile(5) over (partition by (a>10) order by b, a desc) from t_ntile order by 1;

select 1+ntile(4) over (partition by a order by b) from t_ntile order by 1;
select 2*ntile(4) over (partition by a order by b desc) from t_ntile order by 1;
select a, b, a-ntile(5) over (order by a, b) from t_ntile order by 1, 2, 3;
select a+b-ntile(5) over (order by a, b) from t_ntile order by 1;
select 1 from (select ntile(5) over ()+ntile(4) over () from t_ntile order by 1);

select ntile('10') over () from t_ntile order by 1;
select ntile('ab') over () from t_ntile order by 1;
select ntile(6.5) over () from t_ntile order by 1;
select ntile(cast(to_date('2012-12-12') as int)) over () from t_ntile order by 1;
select ntile(cast(to_time('12:00:01 am') as int)) over () from t_ntile order by 1;
select ntile(cast(to_datetime('2012-12-12 12:00:01 am') as int)) over () from t_ntile order by 1;
select ntile(cast(99999999999 as int)) over () from t_ntile order by 1;
select ntile(999999999) over () from t_ntile order by 1;
select ntile(4.49) over () from t_ntile order by 1;
select ntile(4.50) over () from t_ntile order by 1;
select ntile(trunc(4.50)) over () from t_ntile order by 1;
select ntile(ntile(5) over ()) over () from t_ntile order by 1;
select ntile(4) over (order by a, b),ntile(5) over (order by a, b) from t_ntile order by 1, 2;
select ntile((select stddev(a) from t_ntile)) over () from t_ntile order by 1;

select ntile((select 0)) over () from t_ntile order by 1;
select ntile((select a from t_ntile)) over () from t_ntile order by 1;

prepare s from 'select ntile(?) over () from t_ntile order by 1';
execute s using 7;
execute s using '11';
execute s using null;
execute s using 'abc';
drop prepare s;

select ntile(4) over () from t_ntile order by 1;
select ntile(4) over () from t_ntile group by 1;
select ntile(4) over () from t_ntile where a+b>10 order by 1;
select ntile(0) over () from t_ntile order by 1;
select ntile(-1) over () from t_ntile order by 1;

drop table if exists t_ntile;

drop table if exists ntile;

create table ntile(ntile int);
insert into ntile(ntile) values (6),(7),(8);

select ntile from ntile order by 1;
select ntile(0) over () from ntile order by 1;
select ntile(1) over () from ntile order by 1;
select ntile(2) over () from ntile order by 1;
select ntile(3) over () from ntile order by 1;
select ntile(4) over () from ntile order by 1;

select ntile(0) over (order by ntile) from ntile order by 1;
select ntile(1) over (order by ntile) from ntile order by 1;
select ntile(2) over (order by ntile) from ntile order by 1;
select ntile(3) over (order by ntile) from ntile order by 1;
select ntile(4) over (order by ntile) from ntile order by 1;

select ntile(0) over (order by (ntile<7)) from ntile order by 1;
select ntile(1) over (order by (ntile<7)) from ntile order by 1;
select ntile(2) over (order by (ntile<7)) from ntile order by 1;
select ntile(3) over (order by (ntile<7)) from ntile order by 1;
select ntile(4) over (order by (ntile<7)) from ntile order by 1;

select ntile(0) over (partition by ntile) from ntile order by 1;
select ntile(1) over (partition by ntile) from ntile order by 1;
select ntile(2) over (partition by ntile) from ntile order by 1;
select ntile(3) over (partition by ntile) from ntile order by 1;
select ntile(4) over (partition by ntile) from ntile order by 1;

select ntile(0) over (partition by (ntile>7)) from ntile order by 1;
select ntile(1) over (partition by (ntile>7)) from ntile order by 1;
select ntile(2) over (partition by (ntile>7)) from ntile order by 1;
select ntile(3) over (partition by (ntile>7)) from ntile order by 1;
select ntile(4) over (partition by (ntile>7)) from ntile order by 1;

select ntile(0) over (partition by (ntile>7) order by ntile desc) from ntile order by 1;
select ntile(1) over (partition by (ntile>7) order by ntile desc) from ntile order by 1;
select ntile(2) over (partition by (ntile>7) order by ntile desc) from ntile order by 1;
select ntile(3) over (partition by (ntile>7) order by ntile desc) from ntile order by 1;
select ntile(4) over (partition by (ntile>7) order by ntile desc) from ntile order by 1;

select ntile(ntile(3) over ()) over () from ntile order by 1;
select ntile(2) over (),ntile(3) over () from ntile order by 1;

drop table if exists ntile;


