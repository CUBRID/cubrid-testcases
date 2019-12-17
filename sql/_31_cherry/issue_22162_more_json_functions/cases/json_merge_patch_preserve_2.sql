--+ holdcas on;
SELECT JSON_MERGE_PRESERVE('[1, 2]', '[true, false]');
SELECT JSON_MERGE_PATCH('[1, 2]', '[true, false]');

SELECT JSON_MERGE_PRESERVE('[1, 2]', '[5, 6, 7]', '[3, 4]');
SELECT JSON_MERGE_PATCH('[1, 2]', '[5, 6, 7]', '[3, 4]');

SELECT JSON_MERGE_PRESERVE('{"name": "x"}', '{"id": 47}');
SELECT JSON_MERGE_PATCH('{"name": "x"}', '{"id": 47}');

SELECT JSON_MERGE_PRESERVE('{"name": "x"}', '{"id": 47}', '{"age": 20}');
SELECT JSON_MERGE_PATCH('{"name": "x"}', '{"id": 47}', '{"age": 20}');

SELECT JSON_MERGE_PRESERVE('{"name": "x", "id": 37}', '{"id": 47, "age": 30}', '{"age": 20, "name": "y"}');
SELECT JSON_MERGE_PATCH('{"name": "x", "id": 37}', '{"id": 47, "age": 30}', '{"age": 20, "name": "y"}'); 

SELECT JSON_MERGE_PRESERVE('1', 'true');
SELECT JSON_MERGE_PATCH('1', 'true');

SELECT JSON_MERGE_PRESERVE('[1, 2]', '{"id": 47}');
SELECT JSON_MERGE_PATCH('[1, 2]', '{"id": 47}');

SELECT JSON_MERGE_PRESERVE('{ "a": 1, "b": 2 }', '{ "a": 3, "c": 4 }');
SELECT JSON_MERGE_PATCH('{ "a": 1, "b": 2 }', '{ "a": 3, "c": 4 }');

SELECT JSON_MERGE_PRESERVE('{ "a": 1, "b": 2 }','{ "a": 3, "c": 4 }', '{ "a": 5, "d": 6 }');
SELECT JSON_MERGE_PATCH('{ "a": 1, "b": 2 }','{ "a": 3, "c": 4 }', '{ "a": 5, "d": 6 }');

SET @x = '{ "a": 1, "b": 2 }',
    @y = '{ "a": 3, "c": 4 }',
    @z = '{ "a": 5, "d": 6 }';

SELECT  JSON_MERGE_PRESERVE(@x, @y, @z), JSON_MERGE_PATCH(@x, @y, @z);

--NULL test
--CBRD-22555
SELECT JSON_MERGE_PRESERVE(NULL, '[true, false]');
SELECT JSON_MERGE_PATCH(NULL, '[true, false]');

SELECT JSON_MERGE_PRESERVE('[1, 2]', NULL);
SELECT JSON_MERGE_PATCH('[1, 2]', NULL);

SELECT JSON_MERGE_PRESERVE('[1, 2]', NULL, '[3, 4]');
SELECT JSON_MERGE_PATCH('[1, 2]', NULL, '[3, 4]');

SELECT JSON_MERGE_PRESERVE('{ "a": 1, "b": 2 }', '{ "a": null, "c": 4 }');
SELECT JSON_MERGE_PATCH('{ "a": 1, "b": 2 }', '{ "a": null, "c": 4 }');

--empty test
SELECT JSON_MERGE_PRESERVE('', '[true, false]');
SELECT JSON_MERGE_PATCH('', '[true, false]');
SELECT JSON_MERGE_PRESERVE(, '[true, false]');
SELECT JSON_MERGE_PATCH(, '[true, false]');

SELECT JSON_MERGE_PRESERVE('[1, 2]', '');
SELECT JSON_MERGE_PATCH('[1, 2]', '');
SELECT JSON_MERGE_PRESERVE('[1, 2]', );
SELECT JSON_MERGE_PATCH('[1, 2]', );


SELECT JSON_MERGE_PRESERVE('', '{"id": 47}');
SELECT JSON_MERGE_PATCH('', '{"id": 47}');
SELECT JSON_MERGE_PRESERVE(, '{"id": 47}');
SELECT JSON_MERGE_PATCH(, '{"id": 47}');

SELECT JSON_MERGE_PRESERVE('{"name": "x"}', '');
SELECT JSON_MERGE_PATCH('{"name": "x"}', '');
SELECT JSON_MERGE_PRESERVE('{"name": "x"}', );
SELECT JSON_MERGE_PATCH('{"name": "x"}', );

--invalid json
SELECT JSON_MERGE_PRESERVE('{"name": "x"}', '{"id": 47: 57}');
SELECT JSON_MERGE_PATCH('{"name": "x"}', '{"id": 47: 57}');

drop VARIABLE @x,@y,@z;

--+ holdcas off;
