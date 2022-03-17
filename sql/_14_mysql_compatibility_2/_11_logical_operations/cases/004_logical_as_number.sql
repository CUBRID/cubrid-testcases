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



select if(ifnull((i<>0 and j<>0) + (i<>0 or j<>0) - i - j,0)<>0,'wrong','ok') from t order by l;

select i,j,k,cast(1000*sqrt((i<>0 or j<>0)+(j<>0 or k<>0)) as integer) as radikal from t order by l;

select '1' + (i<>0 and j<>0) from t order by l;

select (if(true-1<>0, true, false)-true-true)*(false-true) from db_root;
-- if (1-i,true,false) has to have its return type integer.
-- IF is not allowed to have return type logical, because this would lead to an error in xasl generation
-- because only valid pred expr candidates may have their type set to logical
select if(ifnull(i,1)+if(1-i<>0, true, false)-1<>0,'error','ok') from t;

-- same restriction (no logical can come out of it goes for ifnull)
select i,j,(i<>0 or j<>0),ifnull((i<>0 or j<>0),false) from t where isnull((i<>0 or j<>0))<>0 order by l;

select field((i<>0 or j<>0), 1) from t;
select field(1, (i<>0 or j<>0)) from t;
select field((i<>0 or j<>0), 1,2) from t;
select field(1, (i<>0 or j<>0), 2) from t;
select field(1, 2, (i<>0 or j<>0)) from t;
select field(1, 2, 3, (i<>0 or j<>0)) from t;
select field(1, 2, 3, 4, (i<>0 or j<>0)) from t;
select field(1, 2, 3, 4, (i<>0 or j<>0), 5) from t;


select -(not false) from db_root;

select true + true from db_root;
select true + false from db_root;
select true + 23 from db_root;
select true - 23 from db_root;

select i, ifnull(i,true) from t order by l;

select repeat((i<>0 or j<>0), (i<>0 and j<>0)) from t order by i desc, j desc limit 1;

select (i<>0 or j<>0)-(i<>0 and j<>0) from t order by l;
select (i<>0 or j<>0)/(1+(i<>0 and j<>0)) from t order by l;

-- testing -(not(not i))
select i, -(not(not i<>0)), if (ifnull((-(not(not i<>0)))+i,0)<>0, 'error', 'ok') from t order by l;

select (i<>0 or j<>0) mod 10 from t order by l;
select (i<>0 or j<>0) div 10 from t order by l;

alter table t add column m int;
update t set m = (i<>0 or j<>0);
select sum(m-(i<>0 or j<>0)) as mustbezero from t;

select i, j, if(i+j<>0,'wrong', 'ok') from t where (i<>0 or j<>0) < 1 order by l;

select cast(10000*sin((i<>0 or j<>0)) as integer) from t order by l;


select   abs((i<>0 or j<>0)) from t order by l limit 1;
select round((i<>0 or j<>0)) from t order by l limit 1;

-- should fail
select substring('vlad', 1, (i<>0 or j<>0)) from t order by l;


select (md5((i<>0 and j<>0)) = md5(i*j)) from t where i is not null and j is not null order by l;

-- should also fail
select lpad('vlad', (i<>0 or j<>0)) from t order by l;

select cast((i<>0 or j<>0) as integer) from t order by l;
select cast((i<>0 or j<>0) as varchar(10)) from t order by l;
select cast((i<>0 or j<>0) as numeric(10,4)) from t order by l;

select sec_to_time((i<>0 or j<>0)) from t order by l;

select format((i<>0 or j<>0),(i<>0 and j<>0)) from t order by l;

select (i<>0 and j<>0 and k<>0),((i<>0 and j<>0) or k<>0), case when i<>0 and j<>0 and k<>0 then 1 when (i<>0 and j<>0) or k<>0 then 2 else 3 end from t order by l;

select i, j, (i<>0 or j<>0), (i<>0 and j<>0), nullif ((i<>0 or j<>0), (i<>0 and j<>0)) from t order by l;
select i, j, (i<>0 or j<>0), (i<>0 and j<>0), nullif ((i<>0 or j<>0), 0) from t order by l;
select i, j, (i<>0 or j<>0), (i<>0 and j<>0), nullif (0, (i<>0 or j<>0)) from t order by l;

select coalesce(((i<>0 and j<>0 and k<>0) or l<>0), j,k) from t order by l;

-- case when NVL2 kept pt type logical as its return type
select i,j,(i<>0 and j<>0) + nvl2((i<>0 and j<>0),null,1) as must_be_all_null from t order by l;

-- constant folding after cnf?
select (-5<>0 and 7<>0);


drop table t;
