drop if exists t1;
create table t1(id int auto_increment primary key, c json);

--no_backslash_escapes=yes
SET SYSTEM PARAMETERS 'no_backslash_escapes=yes';
insert into t1(c) values('{"id": "101", "name": "aaa"}');
insert into t1(c) values('{"id": "102", "name": "\u0061\u0061\u0061"}');
insert into t1(c) values('{"id": "103", "name": "\\\u0061\\\u0061\\\u0061"}');
insert into t1(c) values(json_object('id','104','name','\u0061\u0061\u0061'));
insert into t1(c) values('{"id": "105", "name": ["\u0061\u0031", "\u0061\u0032"]}');
insert into t1(c) values(json_object('id','106','name', json_object('name', 'fff1', 'name_old', 'fff2')));

select * from t1 where c->>'$.id'>100 order by id; 
select id, c->'$.id', c->'$.name' from t1 where c->>'$.id'>100 order by id;   
select id, c->>'$.id', c->>'$.name' from t1 where c->>'$.id'>100 order by id; 

--depth test
select id, c->>'$.id', c->>'$.name[1]' from t1 where c->>'$.id'>100 order by id; 
select id, c->>'$.id', c->>'$.name.name' from t1 where c->>'$.id'>100 order by id;  


--no_backslash_escapes=no
SET SYSTEM PARAMETERS 'no_backslash_escapes=no';
select * from t1 where c->>'$.id'>100 order by id; 
select id, c->'$.id', c->'$.name' from t1 where c->>'$.id'>100 order by id;   
select id, c->>'$.id', c->>'$.name' from t1 where c->>'$.id'>100 order by id; 

--depth test
select id, c->>'$.id', c->>'$.name[1]' from t1 where c->>'$.id'>100 order by id; 
select id, c->>'$.id', c->>'$.name.name' from t1 where c->>'$.id'>100 order by id;  


--array test
SET SYSTEM PARAMETERS 'no_backslash_escapes=yes';
drop if exists tj10;
CREATE TABLE tj10 (a JSON, b INT);
INSERT INTO tj10 VALUES ('[3,10,5,"x",44]', 33),('[3,10,5,17,[22,"y",66]]', 0);
SELECT a->'$[3]', a->'$[4][1]' FROM tj10 ORDER BY 1,2;
--the data type of a->>'$[3]' is character(CBRD-22541)
SELECT a->>'$[3]', a->>'$[4][1]' FROM tj10 ORDER BY 1,2;
SELECT a->>'$[3]', a->>'$[4][1]' FROM tj10 where a->'$[4][1]' IS NOT NULL ORDER BY 1,2; 

select json_extract(a,'$[3]'),json_extract(a,'$[4][1]') FROM tj10 ORDER BY 1,2; ; 
--the data type of json_unquote result is character(CBRD-22541)
select json_unquote(json_extract(a,'$[3]')), json_unquote(json_extract(a,'$[4][1]')) FROM tj10 ORDER BY 1,2; 
 

drop t1;
drop tj10;

