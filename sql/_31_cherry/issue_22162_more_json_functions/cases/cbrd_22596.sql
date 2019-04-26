drop table if exists t;
create table t(i int, j int);
insert into t values(1,  1);


-- Sever hangs when execute below query. 
select jt.a from json_table( '{"a":[1,2]}', '$' columns( a varchar(10) path '$.a' )) as jt, t where a=1;

-- If remove 'where a=1' clause, it returns result in time.
select jt.a from json_table( '{"a":[1,2]}', '$' columns( a varchar(10) path '$.a' )) as jt;

select jt.a, json_array(i,j) from json_table( '{"a":[1,2]}', '$' columns( a varchar(10) path '$.a' )) as jt, t;
select jt.a from json_table( '{"a":[1,2]}', '$' columns( a varchar(10) path '$.a' )) as jt, t where a=json_array(1,2);
select jt.a, i from json_table( '{"a":[1,2]}', '$.a[*]' columns( a varchar(10) path '$' )) as jt, t where a<>1;

drop table if exists t;
