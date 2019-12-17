--+ holdcas on;
select json_array_append(null, '/', 1);
select json_array_append(null, '/', '1');
select json_array_append(null, '/',  NULL);
select json_array_append(null, '$', 1);
select json_array_append(null, '$', '1');
select json_array_append(null, '$',  NULL);
select json_array_append('{}', '$',  '{"a": "b"}');
select json_array_append('["a", ["b", "c"], "d"]', '/',  '1');
select json_array_append('["a", ["b", "c"], "d"]', '$[0]',  '1');
select json_array_append('["a", ["b", "c"], "d"]', '$[-1]',  '1');
SET @j = '["a", ["b", "c"], "d"]';
select json_array_append('{"a": 1, "b": {"c": 30}}', '$.a', '2');
select json_array_append('{"a": 1, "b": {"c": 30}}', '/a', '2');
SELECT JSON_ARRAY_APPEND(@j, '$[1][0]', '3');
SELECT JSON_ARRAY_APPEND(@j, '$[1][0]', 3);
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
select JSON_ARRAY_APPEND(@js, '$.store.book[1].author',1);
select json_merge(json_array_append(@js, '$.store', cast(@js as json)), cast(@j as json));
select json_array_append(json_array(name,  @j), '$[0]', $[1]) from t10;  

drop table if exists t1;
create table t1(name json);
insert into t1 values(cast(@j as json));
SELECT JSON_ARRAY_APPEND(@j, '$', cast(@j as json));
select json_array_append(@j, '$', 3);    
select json_array_append(@j, '/', '3');
select json_array_append(@j, '$[2]',  json_array('c', 'd'));
select json_array_append(name, '$' json_merge(@js, @j)) from t1;
select json_array_append(name, '$[1]', name) from t1;
prepare st from 'SELECT JSON_ARRAY_APPEND(@j, ''$'', cast(? as json))';
execute st using @j;

deallocate prepare st;	
drop VARIABLE @j;
drop VARIABLE @js;

drop table if exists t1;



--+ holdcas off;
