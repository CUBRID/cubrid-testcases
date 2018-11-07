
SELECT 
JSON_MERGE_PATCH   ('{"Name":"Jone"}','{"Age":39}'),
JSON_MERGE_PRESERVE('{"Name":"Jone"}','{"Age":39}'); 

SELECT 
JSON_MERGE_PATCH   ('{"Name":"Alen"}','{"Name":"Mark"}'),
JSON_MERGE_PRESERVE('{"Name":"Alen"}','{"Name":"Mark"}'); 

SELECT 
JSON_MERGE_PATCH   ('{"Name":"Alen","Age":10}','{"Name":"Mark"}'),
JSON_MERGE_PRESERVE('{"Name":"Alen","Age":10}','{"Name":"Mark"}'); 

SELECT 
JSON_MERGE_PATCH   ('{"Name":"Alen"}','{"Name":"Mark","Age":10}'),
JSON_MERGE_PRESERVE('{"Name":"Alen"}','{"Name":"Mark","Age":10}'); 

SELECT 
JSON_MERGE_PATCH   ('{"Name":"Mark"}','{"Age":40}','{"Job":"CEO"}'),
JSON_MERGE_PRESERVE('{"Name":"Mark"}','{"Age":40}','{"Job":"CEO"}'); 

SELECT JSON_MERGE_PATCH   ('{"Alphabet":["a","b"]}','{"Alphabet":["c"]}');
-- CBRD-22478
-- SELECT JSON_MERGE_PRESERVE('{"Alphabet":["a","b"]}','{"Alphabet":["c"]}'); 

SELECT 
JSON_MERGE_PATCH   ('{"Alphabet":["a","b"]}','{"Alphabet":["c"]}'),
JSON_MERGE_PRESERVE('{"Alphabet":["a","b"]}','{"Alphabet":["c"]}'); 

set @jd1 = '{ "Alphabet": { "A": "a", "B": ["b", "c"] } }';
set @jd2 = '{ "Alphabet": { "C": 3,   "D": ["d", "e"] } }';
SELECT JSON_MERGE_PATCH(@jd1,@jd2); 
-- CBRD-22478
-- SELECT JSON_MERGE_PRESERVE(@jd1,@jd2); 
drop variable @jd1,@jd2;


SELECT JSON_MERGE_PATCH   ('{"A":["a","b"]}','{"B":["c"]}')
UNION ALL
SELECT JSON_MERGE_PRESERVE('{"A":["a","b"]}','{"B":["c"]}');

