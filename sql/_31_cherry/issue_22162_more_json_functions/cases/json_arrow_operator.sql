drop if exists t1;
create table t1(id int auto_increment primary key, c json);
insert into t1(c) values('{"id": "101", "name": "aaa"}');
insert into t1(c) values(json_object('id','102','name','bbb'));
insert into t1(c) values('{"id": "103", "name": ["ccc1", "ccc2"]}');
set @j = '{"id": "104", "name": ["ddd1", "ddd2"]}';
insert into t1(c) values(@j);
insert into t1(c) values(json_object('id','105','name', json_array('ddd1','ddd2')));
insert into t1(c) values(json_object('id','106','name', '["eee1","eee2"]'));
insert into t1(c) values(json_object('id','107','name', json_object('name', 'fff1', 'name_old', 'fff2')));

--basic test
SELECT id, c->'$.id', c->'$.name' from t1 where id<10 order by 1,2;
SELECT id, c->'/id', c->'/name' from t1 where id<10 order by 1,2;

--test depth>1
SELECT id, c->'$.id', c->'$.name[0]' from t1 where id<10 order by 1,2;
SELECT id, c->'$.id', c->'$.name.name' from t1 where id<10 order by 1,2;
SELECT id, c->'$.id', c->'/name/name' from t1 where id<10 order by 1,2;

--use path in where condition
SELECT id, c->'$.id', c->'$.name' from t1 where c->'$.id'>101 order by 1,2;
SELECT id, c->'$.id', c->'$.name' from t1 where json_extract(c, '$.id') >101 order by c->'$.name';

--type conversion (CBRD-22536)
select id, c->'$.id', c->'$.name' from t1 where c->'$.id'> 102;
select id, c->'$.id', c->'$.name.name' from t1 where c->'$.id'='107';
select id, c->'$.id', c->'$.name' from t1 where c->'$.name'='aaa';

--error test
SELECT id, c->'$.id', c->'$.name'->'$.name' from t1 where id<10 order by 1,2;
SELECT id, c->'$.nn' from t1 where id<5 order by 1,2;
SELECT id, c->'$.name.nn' from t1 where id<5 order by 1,2;
SELECT id, c->'/1' from t1 where id<5 order by 1,2;

--test delete
delete from t1 where c->'$.id'=102;

--test update
update t1 set id=99 where c->'$.id'=107;

--check delete, update result
select * from t1 order by id;

-- JSON array
drop if exists tj10;
CREATE TABLE tj10 (a JSON, b INT);
INSERT INTO tj10 VALUES ('[3,10,5,17,44]', 33), ('[3,10,5,17,[22,44,66]]', 0);
SELECT a->'$[4]' FROM tj10;  
SELECT * FROM tj10 WHERE a->'$[0]' = 3;  
SELECT a, a->'$[4][2]', b FROM tj10 WHERE a->'$[4][1]' IS NOT NULL;
SELECT a, a->'$[0]', b FROM tj10 WHERE a->'$[4][1]' IS NULL;
SELECT JSON_EXTRACT(a, '$[4][1]') FROM tj10;

--error test [2] is recognized as alias here, not array index
SELECT a, a[2], b FROM tj10 WHERE a->'$[4][1]' IS not NULL;

drop t1;
drop tj10;

