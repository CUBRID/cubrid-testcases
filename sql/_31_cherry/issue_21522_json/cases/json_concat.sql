drop table if exists t;
create table t(a int, b json, c json);
insert into t(a,b) values (1, '{"a":"b"}');
insert into t values(2, json_object('a','b'), '["c", "d"]');
select a, concat (a,b) from t order by a;
select a, concat (a,b,c) from t order by a;
select a, concat(json_extract(b, '/'||to_char('a')), json_object('a','b')) from t order by a;

select a, CHR(json_extract(b, '/a')),c from t order by a;
select * from t where concat(json_extract(b, '/'||to_char('a')), json_object('a','b')) is not null order by a;
select a, json_extract( replace( concat( json_extract(b, '/'|| to_char('a')), json_object('a', 'b')), 'b{', '{'), '/a') from t order by a;
drop table if exists t;
