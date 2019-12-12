drop table if exists t;
create table t(a int, b json, c json);
insert into t values(1, json_object('a','b'), '["c", "d"]');
select * from t where b <> json_object('a','b') and c in (json_merge(json_array(c), '["d", "e"]'));
select * from t where b = json_object('a','b');  
select replace((json_merge(json_array(c), '["d", "e"]'), '["name", "c"]'), '[[', '[') from t;

drop table if exists t6;
create table t6(i int , name json);
insert into t6 select 1, json_object('name', 'stuff', 'value', 'third option');
insert into t6 select 2, json_object('name', 'stuff', 'value', 'awesome stuff');
insert into t6 select 3, json_object('name', 'stuff', 'value', 'way cooler stuff');
select * from t6 where cast(json_extract(name, '/name') as varchar) ='stuff' order by json_extract(name, '/value') asc;
select * from t6 where cast(json_extract(name, '/name') as varchar) ='stuff' order by json_extract(name, '/value') desc;
select * from t6 where cast(json_extract(name, '/name') as varchar) ='stuff' order by cast(json_extract(name, '/value') as varchar) asc;
select * from t6 where cast(json_extract(name, '/name') as varchar) ='stuff' order by cast(json_extract(name, '/value') as varchar) desc;

drop table if exists t;
create table t(id int primary key auto_increment, name json, kname json default json_object('key', 'name'));
insert into t(id, name) values(1, '{ "name":"John", "age":31, "city":"New York" }');
insert into t(id, name) values(2, '{"id":"??"}');
insert into t(id, name) values(3, '{"key":"name"}');
select json_extract(name, '/'||json_extract(kname, '/key')) from t where json_extract(name, '/age') >30;

drop table if exists t;
drop table if exists t6;
