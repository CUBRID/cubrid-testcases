--+ holdcas on;

drop table if exists foo;
create table foo (a int );

SELECT /*+ USE_NL(bad_hint) */ * from foo;
DELETE /*+ USE_NL(bad_hint) */ FROM foo;
UPDATE /*+ USE_NL(bad_hint) */ foo SET a = 1;

SELECT //+ USE_NL(bad_hint)
* from foo;
DELETE //+ USE_NL(bad_hint)
FROM foo;
UPDATE //+ USE_NL(bad_hint)
foo SET a = 1;

SELECT --+ USE_NL(bad_hint)
* from foo;
DELETE --+ USE_NL(bad_hint) 
FROM foo;
UPDATE --+ USE_NL(bad_hint) 
foo SET a = 1;

SELECT /*+ USE_IDX(bad_hint) */ * from foo;
DELETE /*+ USE_IDX(bad_hint) */ FROM foo;
UPDATE /*+ USE_IDX(bad_hint) */ foo SET a = 1;

SELECT //+ USE_IDX(bad_hint)
* from foo;
DELETE //+ USE_IDX(bad_hint)
FROM foo;
UPDATE //+ USE_IDX(bad_hint)
foo SET a = 1;

SELECT --+ USE_IDX(bad_hint)
* from foo;
DELETE --+ USE_IDX(bad_hint) 
FROM foo;
UPDATE --+ USE_IDX(bad_hint) 
foo SET a = 1;

SELECT /*+ USE_MERGE(bad_hint) */ * from foo;
DELETE /*+ USE_MERGE(bad_hint) */ FROM foo;
UPDATE /*+ USE_MERGE(bad_hint) */ foo SET a = 1;

SELECT //+ USE_MERGE(bad_hint)
* from foo;
DELETE //+ USE_MERGE(bad_hint)
FROM foo;
UPDATE //+ USE_MERGE(bad_hint)
foo SET a = 1;

SELECT --+ USE_MERGE(bad_hint)
* from foo;
DELETE --+ USE_MERGE(bad_hint) 
FROM foo;
UPDATE --+ USE_MERGE(bad_hint) 
foo SET a = 1;

SELECT /*+ INDEX_SS(bad_hint) */ * from foo;
DELETE /*+ INDEX_SS(bad_hint) */ FROM foo;
UPDATE /*+ INDEX_SS(bad_hint) */ foo SET a = 1;

SELECT //+ INDEX_SS(bad_hint)
* from foo;
DELETE //+ INDEX_SS(bad_hint)
FROM foo;
UPDATE //+ INDEX_SS(bad_hint)
foo SET a = 1;

SELECT --+ INDEX_SS(bad_hint)
* from foo;
DELETE --+ INDEX_SS(bad_hint) 
FROM foo;
UPDATE --+ INDEX_SS(bad_hint) 
foo SET a = 1;


drop table if exists foo;
--+ holdcas off;
