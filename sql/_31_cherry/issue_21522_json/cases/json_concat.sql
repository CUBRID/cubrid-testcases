drop table if exists t;
create table t(a int, b json, c json);
insert into t values(1, json_object('a','b'), '["c", "d"]');
select concat(json_extract(b, '/'||to_char('a')), json_object('a','b')) from t;

select a, CHR(json_extract(b, '/a')),c from t;
select * from t where concat(json_extract(b, '/'||to_char('a')), json_object('a','b')) is not null;
select json_extract( replace( concat( json_extract(b, '/'|| to_char('a')), json_object('a', 'b')), 'b{', '{'), '/a') from t;
drop table if exists t;
