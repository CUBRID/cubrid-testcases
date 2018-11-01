SET @jv = '{  
    "Person": {    
       "Name": "Homer", 
       "Age": 39,
       "Hobbies": ["Eating", "Sleeping"]  
    }
 }';

drop table if exists t;
create table t (a json);
insert into t values (@jv);
select json_pretty(a) from t;

SELECT JSON_LENGTH(a->'$.Person') from t;
SELECT JSON_LENGTH(a->'$.Person.Name') from t;
SELECT JSON_LENGTH(a->'$.Person.Hobbies') from t;
drop variable @jv;

drop table if exists t;
create table t (i int, c json);
insert into t values (2, '{"id": "2", "name": "Wilma"}');
insert into t values (3, '{"id": "3", "name": "Barney"}');
insert into t values (4, '{"id": "4", "name": "Betty"}');

SELECT c, c->'$.id', i FROM t WHERE c->'$.id' > 1 ORDER BY c->'$.name';
SELECT c->'$.name' FROM t WHERE i < 30 ORDER BY c->'$.name';
SELECT JSON_UNQUOTE(c->'$.name') FROM t WHERE i < 30 ORDER BY c->'$.name';
--CBRD-22475
SELECT c->>'$.name'  FROM t WHERE  i < 30 ORDER BY c->'$.name';

DELETE FROM t WHERE c->'$.id' = '4';
SELECT c, c->'$.id', i FROM t WHERE c->'$.id' > 2 ORDER BY c->'$.name';

INSERT INTO t values (33, '[3,10,"x",17,44]'), (30, '[3,10,5,17,[22,44,"y"]]');
SELECT c, c->'$[4]' FROM t order by 1;
SELECT * FROM t WHERE c->'$[0]' = 3 order by 1,2;
SELECT * FROM t WHERE c->'$[4][1]' IS NOT NULL order by 1,2;
SELECT c, c->'$[4][1]' FROM t order by 1;

SELECT i, JSON_UNQUOTE(json_extract(c,'$[2]')) FROM t where i >4 order by 1,2;
SELECT i, JSON_UNQUOTE(c->'$[2]') FROM t where i >4 order by c->>'$[2]';
--CBRD-22475
SELECT i, c->>'$[2]' FROM t where i >4 order by c->>'$[2]';
SELECT i, JSON_UNQUOTE(json_extract(c,'$[4][2]')) FROM t where i >4 order by i;
SELECT i, JSON_UNQUOTE(c->'$[4][2]') FROM t where i >4 order by i;
SELECT i, c->>'$[4][2]' FROM t where i >4 order by i;

drop table if exists t;

