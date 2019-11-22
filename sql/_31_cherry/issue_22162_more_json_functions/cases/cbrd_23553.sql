drop table if exists t2;

create table t2 (a json, b string, i int);
insert into t2 values ( '[null, null]', null, 1);
insert into t2 values ( '{"null": null}', null, 2);
insert into t2 values ( null, null, 3);
select i,json_extract (a, b) from t2 order by 1;
select i,json_extract (a, null) from t2 order by 1;
select i,json_extract (b, b) from t2 order by 1;
select i,json_extract (null, b) from t2 order by 1;

select i,json_keys(a, b) from t2 order by 1;
select i,json_keys(b) from t2 order by 1;
select i,json_keys(a), json_type(json_keys(a)) from t2 order by 1;
select i,json_keys(a,null) from t2 order by 1;
drop table if exists t2;

select json_keys(null);
select json_keys(null,null);
select json_keys(null,null,null);
select json_keys('{"null":null}',null);
select json_keys('{"null":null}',null,null);
select json_keys('{"null":null}', '$.null',null);
select json_keys('{"null":null}', '$',null);
select json_extract ('{"null":null}',null);
select json_extract ('{"null":null}',null,null);
select json_extract ('[null, null]', '$[1]', null);
