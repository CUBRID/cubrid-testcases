-- Basic tests for using integers as logicals
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

-- basic: numbers used as logical
select i,l from t where i order by l;
select i,j,l from t where i or j order by l;
select i,j,l from t where i and j order by l;
select i,j,k,l from t where (i and j) or k order by l;
select i,j,k,l from t where i and (j or k) order by l;
select i,j,k,l from t where i and j or k order by l;
select * from t where not i order by l;
select * from t where i or not j order by l;
select * from t where i and not i order by l;

-- this does not yield the entire table as one would expect: it skips i=NULL
select * from t where i or not i order by l;

-- this SHOULD select the entire table
select count(*) from t where i or not i or i is null;

-- basic: logical used as numeric
select i,j,i+j from t where (i and j) + 1 order by l;
select i,j,i+j+1 from t where ((i and j) + 1 >= 2) order by l;
select i,j,k from t where (i or j or k) = true order by l;
select i,j,k from t where (i or j or k) = false order by l;
select i,j,k from t where (i or j or k) = 1 order by l;

-- true and false and unknown
select i,j,k from t where (i or j or k) is true order by l;
select i,j,k from t where (i or j or k) is false order by l;
select i,j,k from t where (i or j or k) is unknown order by l;

-- just weird
select i,j,k from t where (i = 1) = 1 or (i=0)=1 order by l;


select i, if (i,'one','zero'), if(if(i,i,i)-if(i,1,0),'error','ok') from t order by l;



-- PT_FUNCTIONs:
-- should fail telling that is not defined on logical
select (i or j), insert('abcdefghijklmnopq',(i or j), 4, 'XXX') from t order by l;

-- should be wrapped with cast, so ok
select elt(1, (i or j), 4) from t order by l;


drop table t;
