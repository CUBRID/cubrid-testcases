--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
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
select (1<>0 and ?:0<>0), (1<>0 and ?:1<>0), (?:2<>0 and 0<>0), (0<>0 and ?:3<>0) from db_root;

$int, $1, $int, $0, $int, $1, $int, $0
select (1<>0 or ?:0<>0), (1<>0 or ?:1<>0), (?:2<>0 or 0<>0), (0<>0 or ?:3<>0) from db_root;

-- should fail, hostvar not allowed as truth constant
$int, $1
select * from t where (i or j) is ?;

-- some of these should fail, depending on type conversion rules
$varchar, $testing123
select 'ok' as verdict from db_root where ?:0<>0;

$varchar, $1
select 'ok' as verdict from db_root where ?:0<>0;

$varchar, $000
select 'not-ok' as verdict_empty from db_root where ?:0<>0;

$numeric, $23.071983
select 'ok' as verdict from db_root where ?:0<>0;

$double, $23.071983
select 'ok' as verdict from db_root where ?:0<>0;

-- this will still yield 0 because of integer conversion
$numeric, $0.01
select 'huh?-not-ok' as verdict_empty from db_root where ?:0<>0;

$double, $0.49
select 'not-ok' as verdict_empty from db_root where ?:0<>0;

$date, $2010-07-23
select 'ok' as verdict from db_root where ?:0<>0;

$datetime, $2010-07-23 11:21
select 'ok' as verdict from db_root where ?:0<>0;

$time, $11:21:00
select 'ok' as verdict from db_root where ?:0<>0;

$timestamp, $2010-07-23 11:21:00
select 'ok' as verdict from db_root where ?:0<>0;


drop table t;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
