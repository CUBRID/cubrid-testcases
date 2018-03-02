drop table if exists usera;
create table usera(id int primary key, name varchar(20) , conn_t json);
insert into usera values(1 ,'lily','{"time":"2015-01-01 13:00:00","ip":"192.168.1.1","result":"fail"}');
insert into usera values(2 ,'bobo','{"time":"2015-10-07 06:44:00","ip":"192.168.1.0","result":"success"}');
-- error
insert into usera values(1 ,'lily',json_object('time',NOW(),'ip','192.168.1.1','result','fail'));
select conn_t from usera where name = 'lily';
select * from usera where cast( json_extract(conn_t , '/time') as datetime) > cast('2015-10-02' as datetime) ;
alter table usera add result varchar(15);
update usera set result=json_extract(conn_t,'/result');
select * from usera order by 1,2;
select unique json_keys(conn_t) from usera;
select id, json_get_all_paths(conn_t) from usera order by 1,2;
select id, json_keys(result) from usera order by 1,2;
select id, json_get_all_paths(name) from usera order by 1,2;
drop table if exists usera;

drop table if exists t1;
create table t1 (id int, jdoc json);
insert into t1 values(1, '{"key1": "value1", "key2": "value2"}');
insert into t1 values(2, '["abc", 10, null, true, false]');
insert into t1 values(3, '{"k1": "value", "k2": 10}');
insert into t1 values(4, '["12:18:29.000000", "2015-07-29", "2015-07-29 12:18:29.000000"]');
insert into t1 values(5, '[99, {"id": "HK500", "cost": 75.99}, ["hot", "cold"]]');
insert into t1 values(6, '{"k1": "value", "k2": [10, 20]}');
-- error
insert into t1 values(7, '[1, 2,');
select * from t1 order by 1;
select id, json_keys(jdoc) from t1 order by 1;
select id, json_get_all_paths(jdoc) from t1 order by 1;
drop table if exists t1;

select json_type('["a", "b", 1]');
select json_type('"hello"');
-- error
select json_type('hello');
-- error
select json_array();
select json_array('');
-- error
select json_array('a', 1, now());
-- error
select json_object();
-- error
select json_object('');
select json_object('','');
select json_keys(json_object('',''));
select json_get_all_path(json_object('',''));
select json_keys(json_array(''));
select json_get_all_path(json_array(''));
select json_object('key1', 1, 'key2', 'abc');
select json_merge('["a", 1]', '{"key": "value"}');
select json_keys(json_merge('["a", 1]', '{"key": "value"}'));
select json_get_all_path(json_merge('["a", 1]', '{"key": "value"}'));
SET @j = json_object('key', 'value');
select @j,charset(@j), collation(@j),json_type(@j);
SET @j = '{"key":"value"}';
select @j,charset(@j), collation(@j),json_type(@j);
select json_array('x') = json_array('X');
select json_valid('null'), json_valid('Null'), json_valid('NULL');
select cast('null' as json);
select cast('NULL' as json);
select isnull(null), isnull(Null), isnull(NULL);

drop table if exists facts;
create table facts (sentence json);
insert into facts values (json_object('mascot', '"Sakila"'));
insert into facts values ('{"mascot":"\"Sakila\""}');
select sentence from facts;
select json_extract(sentence, '/mascot') from facts;
select cast(json_extract(sentence, '/mascot') as string) from facts;
drop table if exists facts;


select json_merge('[1, 2]', '["a", "b"]', '[true, false]');
select json_merge('{"a": 1, "b": 2}', '{"c": 3, "a": 4}');
select json_merge('1', '2');
select json_merge('1', '2','1');
select json_merge('[10, 20]', '{"a": "x", "b": "y"}');
select json_merge('[10, 20]', '{"a": "x", "b": "y"}','{"a": "y", "b": "x"}');
select json_merge('{"a": "x", "b": "y"}','{"a": "y", "b": "x"}');

select json_extract('{"id": 14, "name": "Aztalan"}', '/name');
select json_extract(json_array('x'), '/0');

SET @j = '[3, {"a": [5, 6], "b": 10}, [99, 100]]';
select json_extract( @j, '/0'),json_extract( @j, '/1'),
select json_extract( @j, '/2'),json_extract( @j, '/3');
select json_extract( @j, '/1/a'),json_extract( @j, '/1/a/1');
select json_extract( @j, '/1/b'),json_extract( @j, '/2/0');

SET @j = '{"a fish": "shark", "a bird": "sparrow"}';
select json_extract( @j, '/a fish');
select json_extract( @j, '/a bird');
select json_extract('{"a": 1, "b": 2, "c": [3, 4, 5]}', '/c/*');


select json_array('a',1,'b',2) < json_array('b',2,'a',1); 
select json_array('a',1,'b',2) >= json_array('b',2,'a',1);
select json_array('a',1,'b',2) = json_array('b',2,'a',1);
select json_array('a',1,'b',2) = json_array('a',1,'b',2);
select json_object('a',1,'b',2) >= json_object('b',2,'a',1);
select json_object('a',1,'b',2) < json_object('b',2,'a',1);
select json_object('a',1,'b',2) = json_object('b',2,'a',1);
select json_object('a',1,'b',2) = json_object('a',1,'b',2);
drop VARIABLE @j;
