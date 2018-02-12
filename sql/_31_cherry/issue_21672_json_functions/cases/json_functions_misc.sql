drop table if exists t;
create table t(a int, b json, c json);
insert into t values(1, json_object('a','b'), '["c", "d"]');
with cte as (select b, c, json_replace(b,'$', c) as d from t join (select json_set(json_array('c','d'), '$[3]','22')) as c on 1=1) select json_replace(b, '$.a', d) from cte;
with cte as (select b, c, json_merge(b, c) as d from t join (select json_object('key','c')) as dd on 1=1) select json_replace(d, '$[1]', '2') from cte;
with cte as (select json_set(b, '$.a', c) from t union select json_replace(c, '$[1]', cast(a as json)) from t) select * from cte;
with cte(a) as (select json_set(b, '$.a', c) from t union select json_replace(c, '$[1]', cast(a as json)) from t) select json_array_append(a, '$.a', (select json_set(c, '$[1]', '1') from t)) from cte;

with cte(a,b) as (select json_array(a), json_array(json_object('{"a","c"}', a)) as b from t3) select json_replace(a, '$[0]', '1') from cte where json_extract(a, '$[0]') is not  null;

SET @j = '[1.0]';
SELECT JSON_ARRAY_APPEND(@j, '$', '2.0');
SELECT CAST('{"mykey": 5.0}' AS JSON);
SELECT JSON_ARRAY_APPEND(@j, '$',  CAST('{"mykey": 5.0}' AS JSON));
SELECT json_array_append(JSON_ARRAY_APPEND(@j, '$',  CAST('{"mykey": 5.0}' AS JSON)), '$[1]', @j);
with cte as (SELECT json_array_append(JSON_ARRAY_APPEND(@j, '$',  CAST('{"mykey": 5.0}' AS JSON)), '$[1]', @j))select * from cte;
SELECT JSON_ARRAY_APPEND(JSON_ARRAY(1,2,3,4,5),'$',JSON_ARRAY(6,7,8));
select JSON_ARRAY_APPEND(JSON_ARRAY(1,2,3,4,5),'$[2]','99');
SELECT json_array_append(@j, '$', JSON_MERGE(JSON_ARRAY(1,2,3,4,5),JSON_OBJECT('name','Dave')));
SELECT JSON_REPLACE(JSON_ARRAY(1,2,3,4,5),'$[0]','999');
SELECT json_array_append(@j, '', JSON_SET(JSON_ARRAY(1,2,3,4,5),'$[7]','999','$[0]','888','$[2]','777'));
SELECT json_array_append(@j, '$[0]', JSON_SET(JSON_ARRAY(1,2,3,4,5),'$[7]','999','$[0]','888','$[2]','777'), '$[0][1]', JSON_SET(JSON_ARRAY(1,2,3,4,5),'$[7]','999','$[0]','888','$[2]','777'), '$[0][1][2]', @j);

drop VARIABLE @j;

drop table if exists t1;
CREATE TABLE t1 (a JSON NOT NULL, b JSON, id int);
insert into t1 values('{"title": "hello"}', '{"title":["hello",{"type":"object","properties":{"title":{"type":"string"}}}]}', 1);
select json_replace(b, cast(json_extract(json_get_all_paths(b), '$[0]') as string), '1') from t1;  
select json_set(b, cast(json_extract(json_get_all_paths(b), '$[0]') as string), '1') from t1;
select json_array_append(b, cast(json_extract(json_get_all_paths(b), '$[0]') as string), '1') from t1;
select json_set(a, '$.title', json_replace(b, '$.title[0]', json_extract(a, '/title'))) from t1;
select json_set(a, '$.title', json_replace(b, '$.title[0]', json_extract(a, '/title')), '$[1000000000000000000000]', '2222222222222222222222222222222222222222222222222222222222222222222') from t1;
select json_set('{"111": "ccc"}', '$.111', '1');
select json_set('{"111": "ccc"}', '$."111"', '1');
select json_set('{"111": "ccc"}', '$.111', '1', '$."111"', '1');
with recursive cte(m,a) as (select 1 m, json_merge(json_set('{"111": "ccc"}', '$."111"', '1'), b) from t1 union all select 1, json_array_append(a, '$.title', '1111') from t1 union all select m+1, a from cte where m<2) select * from cte  order by 1, 2;
with recursive cte(m,a) as (select 1 m, json_merge(json_set('{"111": "ccc"}', '$."111"', '1'), b) from t1 union all select 1, json_array_append(a, '$.title', '1111') from t1 union all select m+1, a from cte where m<2) select json_replace(cte.a, '$.title', t1.a) from cte, t1 where json_extract(cte.a, '$."111"') is not null  order by 1;
with recursive cte(m,a) as (select 1 m, json_merge(json_set('{"111": "ccc"}', '$."111"', '1'), b) from t1 union all select 1, json_array_append(a, '$.title', '1111') from t1 union all select m+1, a from cte where json_depth(JSON_GET_ALL_PATHS(a))<2) select json_replace(cte.a, '$.title', t1.a) from cte, t1  order by 1;
with recursive cte(m,a) as (select 1 m, json_merge(json_set('{"111": "ccc"}', '$."111"', '1'), b) from t1 union all select 1, json_array_append(a, '$.title', '1111') from t1 union all select m+1, a from cte where json_depth(JSON_GET_ALL_PATHS(a))<2) select JSON_GET_ALL_PATHS(json_replace(cte.a, '$.title', t1.a)) from cte, t1 group by 1 order by 1;
with recursive cte(m,a) as (select 1 m, json_merge(json_set('{"111": "ccc"}', '$."111"', '1'), b) from t1 union all select 1, json_array_append(a, '$.title', '1111') from t1 union all select m+1, a from cte where json_depth(JSON_GET_ALL_PATHS(a))<2) select distinct JSON_GET_ALL_PATHS(json_replace(cte.a, '$.title', t1.a)) from cte, t1 order by 1;
select json_extract('1', '$[0]'), json_set('1', '$[0]', json_object('name', 'cube')), json_set(NULL, '$[0]', json_object('name', 'cube'));
drop table if exists t1;
drop table if exists t;
