--+ holdcas on;

--test1
select timestamp'01/19/2038 12:14:07 pm';

--test2
DROP TABLE IF EXISTS testMaxMinData14;

CREATE TABLE testMaxMinData14(field  timestamp);
INSERT INTO testMaxMinData14 VALUES ('2038-01-19 11:59:59');
SELECT * FROM testMaxMinData14;

DROP TABLE IF EXISTS testMaxMinData14;
--+ holdcas off;
commit;
