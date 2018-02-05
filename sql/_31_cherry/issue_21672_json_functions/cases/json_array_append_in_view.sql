drop table if exists t1;
drop view if exists v1;
create table t1 (a json NOT NULL, b json, id int );
insert into t1 values ('{"title": "hello"}', null , 1);
create view v1 as select * from t1;
update v1 set b = json_array_append(a, '$.title', '{ "type": "object", "properties": { "title": { "type": "string" } }}');
select * from t1;
drop view if exists v2;
create view v2 as select json_array_append(b, '$.title[1]', '{"aa":"ccc"}') as c from t1; 
select * from v2;
drop view if exists v2;
create view v2 as select json_array_append(b, '$.title[1]', '{"aa":"ccc"}') as c from t1 where json_array_append('{}', '$', b) is not null;
--crash
--select * from v2;
--select json_array_append(c, '$.title', '{}') from v2;  
drop view if exists v2;
drop view if exists v1;
drop table if exists t1;

