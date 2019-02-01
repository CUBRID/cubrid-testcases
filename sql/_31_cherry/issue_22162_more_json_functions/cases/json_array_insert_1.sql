select json_array_insert(null, '/', 1);
select json_array_insert(null, '/', '1');
select json_array_insert(null, '/',  NULL);
select json_array_insert(null, '$', 1);
select json_array_insert(null, '$', '1');
select json_array_insert(null, '$',  NULL);
select json_array_insert('{}', '$',  '{"a": "b"}');
--CBRD-22613 
select json_array_insert('["a", ["b", "c"], "d"]', '/',  '1');
select json_array_insert('["a", ["b", "c"], "d"]', '$[0]',  '1');
select json_array_insert('["a", ["b", "c"], "d"]', '$[-1]',  '1');
--CBRD-22612 
select json_array_insert('{"a": 1, "b": {"c": 30}}', '$.a', '2');
--CBRD-22612 
select json_array_insert('{"a": 1, "b": {"c": 30}}', '/a', '2');
--CBRD-22612 
select json_array_insert('["a", "b"]', '$', 'false');
--CBRD-22612 
select json_array_insert('{"k1":1, "k2":["a", "b"]}', '$.k2', '2');
--CBRD-22612 
select json_array_insert('["a", ["b", "c"], "d"]', '$[0]', '2');

set @js='{ "store": {
    "book": [ 
      { "category": "reference",
        "author": "Nigel Rees",
        "title": "Sayings of the Century",
        "price": 8.95
      },
      { "category": "fiction",
        "author": "Evelyn Waugh",
        "title": "Sword of Honour",
        "price": 12.99
      },
      { "category": "fiction",
        "author": "Herman Melville",
        "title": "Moby Dick",
        "isbn": "0-553-21311-3",
        "price": 8.99
      },
      { "category": "fiction",
        "author": "J. R. R. Tolkien",
        "title": "The Lord of the Rings",
        "isbn": "0-395-19395-8",
        "price": 22.99
      }
    ],
    "bicycle": {
      "color": "red",
      "price": 19.95
    }
  }
}';
--CBRD-22612 
select json_array_insert(@js, '$.store.book[1].author',1);
--CBRD-22612 
select json_merge(json_array_insert(@js, '$.store', cast(@js as json)), cast(@j as json));
drop VARIABLE @js;

SET @j = '["a", ["b", "c"], "d"]';
SELECT json_array_insert(@j, '$[1][0]', '3');
SELECT json_array_insert(@j, '$[1][0]', 3);
SELECT json_array_insert(@j, '$', cast(@j as json));
select json_array_insert(@j, '$', 3);
--CBRD-22613 
select json_array_insert(@j, '/', '3');
select json_array_insert(@j, '$[2]',  json_array('c', 'd'));

drop table if exists t1;
create table t1(name json);
insert into t1 values(cast(@j as json));
select json_array_insert(name, '$' json_merge(@js, @j)) from t1;
select json_array_insert(name, '$[1]', name) from t1;
prepare st from 'SELECT json_array_insert(@j, ''$'', cast(? as json))';
execute st using @j;
deallocate prepare st;
drop VARIABLE @j;
drop table if exists t1;

SET @j = '[1.0]';
SELECT json_array_insert(@j, '$', '2.0');
SELECT CAST('{"mykey": 5.0}' AS JSON);
SELECT json_array_insert(@j, '$',  CAST('{"mykey": 5.0}' AS JSON));
SELECT json_array_insert(json_array_insert(@j, '$',  CAST('{"mykey": 5.0}' AS JSON)), '$[1]', @j);
with cte as (SELECT json_array_insert(json_array_insert(@j, '$',  CAST('{"mykey": 5.0}' AS JSON)), '$[1]', @j))select * from cte;
SELECT json_array_insert(JSON_ARRAY(1,2,3,4,5),'$',JSON_ARRAY(6,7,8));
select json_array_insert(JSON_ARRAY(1,2,3,4,5),'$[2]','99');
SELECT json_array_insert(@j, '$', JSON_MERGE(JSON_ARRAY(1,2,3,4,5),JSON_OBJECT('name','Dave')));
SELECT JSON_REPLACE(JSON_ARRAY(1,2,3,4,5),'$[0]','999');
SELECT json_array_insert(@j, '', JSON_SET(JSON_ARRAY(1,2,3,4,5),'$[7]','999','$[0]','888','$[2]','777'));
SELECT json_array_insert(@j, '$[0]', JSON_SET(JSON_ARRAY(1,2,3,4,5),'$[7]','999','$[0]','888','$[2]','777'), '$[0][1]', JSON_SET(JSON_ARRAY(1,2,3,4,5),'$[7]','999','$[0]','888','$[2]','777'), '$[0][1][2]', @j);
drop VARIABLE @j;

select JSON_OBJECT('a',NULL),JSON_ARRAY('a','b',NULL);
select JSON_ARRAY_APPEND('["a", "b"]', '$', NULL);  
select JSON_ARRAY_APPEND(NULL, '$', '["a", "b"]');
select json_array_insert('["a", "b"]', '$', NULL);  
select json_array_insert(NULL, '$', '["a", "b"]');

set @j = '["a", ["b", "c"], "d"]';
select json_keys(json_array_insert(@j, '/1', '1','/0', '2', '/2', '4','/2/0', '5'));
--CBRD-22613 
select json_array_insert(@j, '/1', '1','/0', '2', '/2', '3','/', '4');
select json_array_insert(@j, '/1', '1','/0', '2', '/2', '3','', '4');
select json_array_insert(@j, '/1', '1','/0', '2', '/2', '3','$', '4');
select json_array_insert(@j, '/1', '1');
select json_array_insert(@j, '/0', '2');
select json_array_insert(@j, '/1/0', '3');
select json_array_insert(@j, '/1', '1','/0', '2', '/1/0', '3');
select json_array_insert(@j, '/1', '1','/0', '2', '/1/0', '3', '/1/0', '4');
--error
select json_array_insert(@j, '/1', '1','/0', '2', '/3', '3', '/3/','"x"');
select json_array_insert(@j, '/1', '1','$[0]', '2', '/2', '3');
select json_array_insert(@j, '/1', '1','/0', '2', '/2', '{"aaa":"12344"}');
select json_array_insert(@j, '/1', '1','/0', '2', '/2', '3','/', '4');
select json_array_insert(@j, '/1', null);
select json_array_insert(@j, '/0', '{"key":[9,8,"a"]}', '/0/1/key', '"x"');
select json_array_insert(@j, '/0', cast('{"key":[9,8,"a"]}' as json), '/0/1/key', 'x');

set @j = null;
select json_array_insert(@j, '/1', '1');
select json_array_insert(@j, '/', null);

SET @j = '{"a": 1, "b": [2, 3], "c": 4}';
--CBRD-22663
select json_array_insert('{"a": 1}', '$.d', 'z');
select json_array_insert('{"a": 1}', '$.""', 'z');
select json_array_insert(@j, '/', '"z"');
select json_array_insert(@j, '', '"z"');
select json_array_insert(@j, '/a', '"z"');
select json_array_insert(@j, '$', '"z"');
select json_array_insert(@j, '/b', '"x"');
select json_array_insert(@j, '/c', '"y"');
select json_array_insert(@j, '/b', '"x"','/b', '"x"');
select json_array_insert(@j, '/b', '"x"','/b/2','"y"');

drop VARIABLE @j;


