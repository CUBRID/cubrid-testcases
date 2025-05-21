/**
 *  This test case verifies CBRD-25874: Problem with USE_HASH and NO_USE_HASH hints applying even if all arguments are invalid
 */

drop if exists t1;
create table t1 (c1 int, c2 int);
insert into t1 select rownum, rownum from db_class limit 10;

drop if exists t2;
create table t2 (c1 int, c2 int);
insert into t2 select rownum, rownum from db_class limit 10;

drop if exists t3;
create table t3 (c1 int, c2 int);
insert into t3 select rownum, rownum from db_class limit 10;

evaluate 'TEST 1: Invalid USE_HASH column: USE_HASH hint should be ignored.';
--@queryplan
select /*+ recompile use_hash(unknown) */ count (*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 2: Valid USE_HASH columns with invalid column: USE_HASH hint for valid columns should NOT be ignored.';
--@queryplan
select /*+ recompile use_hash(a,b,unknown) */ count (*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 3: Invalid NO_USE_HASH column: NO_USE_HASH hint should be ignored and USE_HASH hint for valid columns should be applied.';
--@queryplan
select /*+ recompile use_hash(a,b) no_use_hash(unknown) */ count (*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 4: Valid NO_USE_HASH columns: NO_USE_HASH and USE_HASH hints should be applied to all valid columns';
--@queryplan
select /*+ recompile use_hash(a) no_use_hash(b,c,unknown) */ count (*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 5: Invalid USE_HASH column with NO_USE_HASH: NO_USE_HASH should be applied';
--@queryplan
select /*+ recompile use_hash(unknown) no_use_hash */ count (*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;


evaluate 'TEST 6: Invalid USE_HASH column with valid NO_USE_HASH columns: NO_USE_HASH should be applied to all valid columns';
--@queryplan
select /*+ recompile use_hash(unknown) no_use_hash(a,b) */ count (*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;


evaluate 'TEST 7: Invalid NO_USE_HASH column with USE_HASH: USE_HASH should be applied to all valid columns';
--@queryplan
select /*+ recompile no_use_hash(invalid) use_hash  */ count (*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;


evaluate 'TEST 8: Invalid NO_USE_HASH column with valid USE_HASH columns: USE_HASH should be applied to all valid columns';
--@queryplan
select /*+ recompile no_use_hash(invalid) use_hash(a,b)  */ count (*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 9: Empty USE_HASH with NO_USE_HASH columns: NO_USE_HASH should be applied to all valid columns.';
--@queryplan
select /*+ recompile no_use_hash(a,b) use_hash() */ count(*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 10: Empty NO_USE_HASH with USE_HASH columns - USE_HASH should be applied to all valid columns';
--@queryplan
select /*+ recompile use_hash(a,b) no_use_hash() */ count(*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 11: Both USE_HASH and NO_USE_HASH hints used with invalid arguments: Hash Join should not be applied';
--@queryplan
select /*+ recompile use_hash(invalid1) no_use_hash(invalid2) */ count(*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 12: USE_HASH alongside USE_HASH/NO_USE_HASH with no columns: Hash join should be applied.';
--@queryplan
select /*+ recompile use_hash use_hash() no_use_hash() */ count(*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 13: NO_USE_HASH alongside USE_HASH/NO_USE_HASH with no columns: Hash join should not be applied.';
--@queryplan
select /*+ recompile no_use_hash use_hash() no_use_hash() */ count(*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 14: USE_HASH alongside USE_HASH/NO_USE_HASH with invalid columns: Hash join should be applied.';
--@queryplan
select /*+ recompile use_hash use_hash(invalid) no_use_hash(invalid) */ count(*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 15: NO_USE_HASH alongside USE_HASH/NO_USE_HASH with invalid columns: Hash join should not be applied.';
--@queryplan
select /*+ recompile no_use_hash use_hash(invalid) no_use_hash(invalid) */ count(*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 16: Multiple invalid USE_HASH columns (3): USE_HASH hint should be ignored.';
--@queryplan
select /*+ recompile use_hash(unknown1, unknown2, unknown3) */ count (*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 17: Multiple invalid NO_USE_HASH columns (3): NO_USE_HASH hint should be ignored and USE_HASH hint for valid columns should be applied.';
--@queryplan
select /*+ recompile use_hash(a,b) no_use_hash(unknown1, unknown2, unknown3) */ count (*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 18: Invalid USE_HASH column alongside USE_HASH: Cache hint(s) should not be applied.';
--@queryplan
select /*+ recompile use_hash(unknown) use_hash */ count (*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

evaluate 'TEST 19: Invalid NO_USE_HASH column alongside NO_USE_HASH: Cache hint(s) should not be applied.';
--@queryplan
select /*+ recompile no_use_hash(unknown) no_use_hash */ count (*)
from t1 a, t2 b, t3 c
where a.c1 = b.c1 and b.c2 = c.c2;

drop table t1;
drop table t2;
drop table t3;


