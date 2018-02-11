SET @j = '{"a": 1, "b": 2, "c": {"d": 4}}';
SET @j2 = '1';
SELECT JSON_CONTAINS(@j, @j2, '$.a');
SELECT JSON_CONTAINS(@j, @j2, '$.b');
SET @j2 = '{"d": 4}';
SELECT JSON_CONTAINS(@j, @j2, '$.a');
SELECT JSON_CONTAINS(@j, @j2, '$.c');

SELECT JSON_EXTRACT('[10, 20, [30, 40]]', '$[0]');
SELECT JSON_EXTRACT('[10, 20, [30, 40]]', '$[1]');
SELECT JSON_EXTRACT('[10, 20, [30, 40]]', '$[2]');
SELECT JSON_EXTRACT('[10, 20, [30, 40]]', '$[2][1]');
-- error
SELECT JSON_EXTRACT('[10, 20, [30, 40]]', '$[1]', '$[0]');
-- error
SELECT JSON_EXTRACT('[10, 20, [30, 40]]', '$[2][*]');

drop table if exists t;
create table t ( i int, c json);
insert into t values (1, '{"id":"1","name":"apple"}');
insert into t values (2, '{"id":"2","name":"banana"}');
insert into t values (3, '{"id":"3","name":"candy"}');
insert into t values (4, '{"id":"4","name":"donkey"}');
SELECT c, JSON_EXTRACT(c, '$.id'), i FROM t WHERE JSON_EXTRACT(c, '$.id') > 1 ORDER BY JSON_EXTRACT(c, '$.name');
ALTER TABLE t ADD COLUMN n INT;
UPDATE t SET n=1 WHERE JSON_EXTRACT(c, '$.id') = '"4"';
SELECT c, JSON_EXTRACT(c, '$.id'), i, n FROM t WHERE JSON_EXTRACT(c, '$.id') > 1  ORDER BY JSON_EXTRACT(c, '$.name');
DELETE FROM t WHERE JSON_EXTRACT(c, '$.id') = '"4"';
SELECT c, JSON_EXTRACT(c, '$.id'), i, n FROM t WHERE JSON_EXTRACT(c, '$.id') > 1  ORDER BY JSON_EXTRACT(c, '$.name');
--error
SELECT c, c->"$.id", id FROM t WHERE c->"$.id" > 1 ORDER BY c->"$.name";

INSERT INTO t(i,c) VALUES (33, '[3,10,5,17,44]'), (30, '[3,10,5,17,[22,44,66]]');
--CBRD-21876
--SELECT c ,JSON_KEYS(JSON_EXTRACT(c, '$[4][1]')) FROM t ORDER by 2,1;
SELECT c, JSON_EXTRACT(c, '$[4]') FROM t ORDER BY 2,1;
SELECT * FROM t WHERE JSON_EXTRACT(c, '$[4][1]') is not null order by 1;
SELECT * FROM t WHERE JSON_EXTRACT(c, '$[0]')= 3 order by c;
--error
SELECT c->"$[4]" FROM t;
--error
SELECT * FROM t WHERE c->"$[0]" = 3;
--error
SELECT * FROM t WHERE c->"$[4][1]" IS NOT NULL;
--error
select JSON_EXTRACT(c, '$[*]' )from t order by 1;

drop table if exists t;


set @j='{ "store": {
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
--CBRD-21876	
--select json_keys(@j);
select json_get_all_paths(@j);
select json_extract (@j, '$.store.book[0].category');
select json_extract (@j, '/store/book/0/category');
select json_extract (@j, '$.store.book[0]');
select json_extract (@j, '/store/book/0');
select json_extract (@j, '/store/book/0/');
select json_extract (@j, '$.store.book');
select json_extract (@j, '/store/book');
select json_extract (@j, '$.store');
select json_extract (@j, '/store');
select json_extract (@j, '$');
select json_extract (@j, '/');
select json_extract (@j, '$.*');
select json_extract (@j, '/*');
select json_extract (@j, '//');
select json_extract (@j, '');
select json_extract (@j, '$.store.book[*].author') ;
select json_extract (@j, '$.store..price');
select json_extract (@j, '$..book[0,1]');

drop VARIABLE @j;
