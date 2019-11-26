--+ holdcas on;
--test for CBRD-22531(use multi path as parameters)
SELECT JSON_EXTRACT('[10, 20, [30, 40]]', '$[1]');
SELECT JSON_EXTRACT('[10, 20, [30, 40]]', '$[1]', '$[0]');
set @j1='{"id":"109","name":["hhh1", ["hhh2","hhh3"], "hhh4", "hhh5"], "name_old":"hhh6"}';
set @j2='$.id';
set @j3='$.name[0]';
set @j4='$.name[1][1]';
set @j5='$.name_old';
SELECT JSON_EXTRACT(@j1, '$.id', '$.name[0]', '$.name[1][1]', '$.name_old');
SELECT JSON_EXTRACT(@j1, @j2, @j3, @j4, @j5);
drop variable @j1,@j2,@j3,@j4,@j5;

--CBRD-23072 
SELECT json_extract('{"name_old":"hhh6"}', '$."name_old"');
SELECT json_extract('{"name_old":"hhh6"}', '$.name_old');

--CBRD-22540 wildcard test
SELECT JSON_EXTRACT('[10, 20, [30, 40]]', '$[2][*]');


--test in table
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
insert into t1(c) values(json_object('id','108','name', json_object('name', json_array('ggg1','ggg2'), 'name_old', 'ggg3')));
insert into t1(c) values(json_object('id','109','name', json_array('hhh1', json_array('hhh2','hhh3'), 'hhh4', 'hhh5')));
drop variable @j;

--basic test
select id, json_extract(c, '$.id', '$.name') from t1 order by 1,2;
select id, json_extract(c, '/id', '/name') from t1 order by 1,2;

--test depth>1
SELECT id, json_extract(c, '$.id'), json_extract(c, '$.id', '$.name[0]', '$.name[1]') from t1 where id<10 order by 1,2,3;
SELECT id, json_extract(c, '$.id'), json_extract(c, '$.id', '$.name[0]', '$.name[0][1]','$.name[1][1]') from t1 where id<10 order by 1,2,3;
SELECT id, json_extract(c, '$.id'), json_extract(c, '$.id', '$.name.name', '$.name.name[0]', '$.name.name[1]', '$.name.name_old') from t1 where id<10 order by 1,2,3;

--error test
SELECT id, json_extract(c, c->'$.name'->'$.name') from t1 where id<10 order by 1,2;

drop t1;


--+ holdcas off;
