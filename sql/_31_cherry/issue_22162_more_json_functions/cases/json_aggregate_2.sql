select * from json_table('{"a":1}', '$' columns (v int path '$.a')) as jt;
select * from json_table('{"a":1}', '$' columns (v int path '$.a')) jt;

DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (
  skey  varchar(8) DEFAULT NULL,
  grp varchar(8) DEFAULT NULL,
  val varchar(8)
);
INSERT INTO t1(skey, grp, val) VALUES
 ('key1', 'g1', 'v1'),
 ('key2', 'g1', 'v2'),
 ('key3', 'g2', 'v3');
SELECT JSON_ARRAYAGG(skey) AS "Keys" FROM t1;
SELECT grp, JSON_ARRAYAGG(skey) AS keys_grouped FROM t1  GROUP BY grp order by 1;
SELECT JSON_OBJECTAGG(skey, val) AS key_val FROM t1;
SELECT grp, JSON_OBJECTAGG(skey, val) AS key_val_grouped FROM t1 GROUP BY grp order by 1;
DROP TABLE IF EXISTS t1;

drop table if exists too;
create table too ( id int , name varchar(10));   
insert into too values ( 1, 'a'), (1, 'b'), (2, 'aa'), (3, 'aaa'), (3, 'bbb'), (3, 'ccc');
select id, json_object('key', json_arrayagg(name)) as j from too group by id order by j;

-- http://jira.cubrid.org/browse/CBRD-22598
-- select id, json_object('key', json_arrayagg(name)) as j from too group by id order by j->'$.key';
-- select id as i from too  order by id+id;

-- http://jira.cubrid.org/browse/CBRD-22599
select t.j->'$.key' from (select id, json_object('key', json_arrayagg(name)) as j from too group by id ) as t order by 1;
select json_extract(t.j,'$.key') from(select id, json_object('key', json_arrayagg(name)) as j from too group by id ) as t order by 1;

select t.j->>'$.key' from (select id, json_object('key', json_arrayagg(name)) as j from too group by id ) as t order by 1;
select t.j->>'$.key[0]' from (select id, json_object('key', json_arrayagg(name)) as j from too group by id ) as t order by 1;
select json_quote(t.j->'$.key[0]') from (select id, json_object('key', json_arrayagg(name)) as j from too group by id ) as t order by 1;
select json_unquote(t.j->'$.key[0]') from (select id, json_object('key', json_arrayagg(name)) as j from too group by id ) as t order by 1;
select * from (select id, json_object('key', json_arrayagg(name)) as j from too group by id ) as t where t.j->>'$.key[0]' like '%b%' order by 1;

-- http://jira.cubrid.org/browse/CBRD-22599
--select id as i from too  order by i+i;
drop table if exists too;

drop table t0;
create table t0 ( s varchar(50), j json);
insert into t0 set s='{"key": ["aaa", "bbb", "ccc"]}',  j=s;
insert into t0 set s='{"key": ["a", "b"]}',  j=s;
insert into t0 set s='{"key": ["aa"]}',  j=s;
select s, j, j->'$.key' as v from t0 order by s;
select s, j, j->'$.key' as v from t0 order by j;
select s, j, j->'$.key' as v from t0 order by v;
drop table t0;

set @j='[1,2,3]';
select group_concat(val) from json_table(json_extract(@j, '$[*]', '$');
select * from json_table(json_extract(@j, '$[*]', '$')) as jt;
set @j=' ';
select group_concat(val) from json_table(json_extract(@j, '$[*]', '$');
select * from json_table(json_extract(@j, '$[*]', '$')) as jt;

SELECT *
FROM
  JSON_TABLE(
    '[{"x":2,"y":"8"},{"x":"3","y":"7"},{"x":"4","y":6}]',
    '$[*]' COLUMNS(
      xval VARCHAR(100) PATH '$.x',
      yval VARCHAR(100) PATH '$.y'
    )
  ) AS  jt1 
order by 1,2;

Drop table if exists t1;
CREATE TABLE t1(json_col JSON); 
INSERT INTO t1 VALUES (
    '{ "people": [
        { "name":"John Smith",  "address":"780 Mission St, San Francisco, CA 94103"}, 
        { "name":"Sally Brown",  "address":"75 37th Ave S, St Cloud, MN 94103"}, 
        { "name":"John Johnson",  "address":"1262 Roosevelt Trail, Raymond, ME 04071"}
     ] }'
);
SELECT people.* 
FROM t1, 
     JSON_TABLE(json_col, '$.people[*]' COLUMNS (
                name VARCHAR(40)  PATH '$.name',
                address VARCHAR(100) PATH '$.address')
     ) people 
order by name;

SELECT people.* 
FROM t1, 
     JSON_TABLE(json_col, '$.people[*]' COLUMNS (
                name VARCHAR(40)  PATH '$.name',
                address VARCHAR(100) PATH '$.address')
     ) as people
WHERE people.name LIKE 'John%' 
order by name;	 

Drop table if exists t1;
drop variable @j;
