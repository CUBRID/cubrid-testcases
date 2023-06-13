--+ holdcas on;
-- tests that the query plans and the cache keys work as expected
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
create index i_t_k on t(k);
create index i_t_l  on t(l);
update statistics on t;

select count(*) from t where 1;
select count(*) from t where 0;
select count(*) from t where NULL;

select * from t where i and l=4;
select /*+ USE_IDX i_t_i */ * from t where not i and l=4;

select if(sum(i)-sum(j),'nok', 'ok') from t where i and j;
select * from t where (l > 7) and ((i and j) or (j and k)) order by l;

select * from t where (i or j) in (select k from t order by k desc limit 1) order by l;

select i, j, (i and j), l mod 2, (not (l mod 2))
from t
where (i or j) in
	(	select l from t where not (l mod 2) and i < 13
		union
		select l from t where ((l mod 2) = (i and j))
	)
order by l;


select (i and j and k),((i and j) or k), case when i and j and k then 1 when (i and j) or k then 2 else 3 end from t order by l;


select * from t where not (not (not (not ( !i)))) order by l;


drop table t;
commit;
--+ holdcas off;
