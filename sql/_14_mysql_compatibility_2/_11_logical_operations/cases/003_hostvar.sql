--+ holdcas on;
create table t (i int, j int, k int, l int);
insert into t values
(0,0,0,0),
(0,0,1,1),
(0,1,0,2),
(0,1,1,3),
(1,0,0,4),
(1,0,1,5),
(1,1,0,6),
(1,1,1,7),
(null, 0, 0, 8),
(null, 1, 1, 9),
(0, null, 0, 10),
(1, null, 1, 11),
(0, 0, null, 12),
(1, 1, null, 13),
(null, null, null, 14);

create index i_t_i on t(i);
create index i_t_j  on t(j);
create index i_t_k  on t(k);
create index i_t_l on t(l);



$int, $1, $int, $0, $int, $1, $int, $0
select (1 and ?), (1 and ?), (? and 0), (0 and ?) from db_root;

$int, $1, $int, $0, $int, $1, $int, $0
select (1 or ?), (1 or ?), (? or 0), (0 or ?) from db_root;

-- should fail, hostvar not allowed as truth constant
$int, $1
select * from t where (i or j) is ?;

-- some of these should fail, depending on type conversion rules
$varchar, $testing123
select 'ok' as verdict from db_root where ?;

$varchar, $1
select 'ok' as verdict from db_root where ?;

$varchar, $000
select 'not-ok' as verdict_empty from db_root where ?;

$numeric, $23.071983
select 'ok' as verdict from db_root where ?;

$double, $23.071983
select 'ok' as verdict from db_root where ?;

-- this will still yield 0 because of integer conversion
$numeric, $0.01
select 'huh?-not-ok' as verdict_empty from db_root where ?;

$double, $0.49
select 'not-ok' as verdict_empty from db_root where ?;

$date, $2010-07-23
select 'ok' as verdict from db_root where ?;

$datetime, $2010-07-23 11:21
select 'ok' as verdict from db_root where ?;

$time, $11:21:00
select 'ok' as verdict from db_root where ?;

$timestamp, $2010-07-23 11:21:00
select 'ok' as verdict from db_root where ?;


drop table t;
commit;
--+ holdcas off;
