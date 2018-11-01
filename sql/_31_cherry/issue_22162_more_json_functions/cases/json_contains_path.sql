--https://database.guide/json_contains_path-examples-in-mysql/

--http://jira.cubrid.org/browse/CBRD-22452
SET @doc = '{"a": 1, "b": 2, "c": {"d": 3}}';
SELECT JSON_CONTAINS_PATH(@doc, 'one', '$.a') ; 
SELECT JSON_CONTAINS_PATH(@doc, 'all', '$.a') ; 
SELECT JSON_CONTAINS_PATH(@doc, 'one', '$.z') ; 
SELECT JSON_CONTAINS_PATH(@doc, 'one', '$.a', '$.z') ; 
SELECT JSON_CONTAINS_PATH(@doc, 'all', '$.a', '$.z') ; 
SELECT JSON_CONTAINS_PATH(@doc, 'all', '$.c.d') ; 

SET @doc = '{"a": 1, "b": 2, "c": [3, 4, 5]}';
SELECT JSON_CONTAINS_PATH(@doc, 'all', '$.c[0]') ; 
SELECT JSON_CONTAINS_PATH(@doc, 'all', '$.c[3]') ; 

