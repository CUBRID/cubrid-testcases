/* Description
Related the CBRD-24581.
The verification to create the index by composite with IFNULL(), NULLIF(), and NVL() functions on the table.
*/

drop if exists t1, t2, t3, t4;
drop if exists view_t1, view_t2, view_t3, view_t4;
drop if exists part_t1, part_t2, part_t3, part_t4;

-- IFNULL()
create table t1( a char(10), b short);
create index idx_t1 on t1(IFNULL(a,'a'), b);
select /*+ RECOMPILE */* from t1 where IFNULL(a,'a')='a' using index idx_t1(+);

-- view - IFNULL()
create view view_t1 as select * from t1;
select /*+ RECOMPILE */* from view_t1 where IFNULL(a,'a')='a' using index idx_t1(+);


-- NULLIF()
create table t2( a char(10), b short );
create index idx_t2 on t2(NULLIF(a,'a'), b);
select /*+ RECOMPILE */* from t2 where NULLIF(a,'a')='a' using index idx_t2(+);

-- view - NULLIF()
create view view_t2 as select * from t2;
select /*+ RECOMPILE */* from view_t2 where NULLIF(a,'a')='a' using index idx_t2(+);


-- NVL()
create table t3( a char(10), b short);
create index idx_t3 on t3(NVL(a,'a'), b);
select /*+ RECOMPILE */* from t3 where NVL(a,'a')='a' using index idx_t3(+);

-- view - NVL()
create view view_t3 as select * from t3;
select /*+ RECOMPILE */* from view_t3 where NVL(a,'a')='a' using index idx_t3(+);


-- NVL2()
create table t4( a char(10), b short);
create index idx_t4 on t4(NVL2(a,'a','z'), b);
select /*+ RECOMPILE */* from t4 where NVL2(a,'a','z')='a' using index idx_t4(+);

-- view - NVL2()
create view view_t4 as select * from t4;
select /*+ RECOMPILE */* from view_t4 where NVL2(a,'a','z')='a' using index idx_t4(+);


-- partition table - IFNULL()
create table part_t1(
    a char(1), b short
) PARTITION BY RANGE (a) (
    PARTITION less_c VALUES LESS THAN ('c'),
    PARTITION char_else VALUES LESS THAN MAXVALUE
);
create index idx_part_t1 on part_t1(IFNULL(a,'a'), b);
select /*+ RECOMPILE */* from part_t1 where IFNULL(a,'a')='a' using index idx_part_t1(+);


-- partition table - NULLIF()
create table part_t2(
    a char(1), b short
) PARTITION BY RANGE (a) (
    PARTITION less_c VALUES LESS THAN ('c'),
    PARTITION char_else VALUES LESS THAN MAXVALUE
);
create index idx_part_t2 on part_t2(NULLIF(a,'a'), b);
select /*+ RECOMPILE */* from part_t2 where NULLIF(a,'a')='a' using index idx_part_t2(+);


-- partition table - NVL()
create table part_t3(
    a char(1), b short
) PARTITION BY RANGE (a) (
    PARTITION less_c VALUES LESS THAN ('c'),
    PARTITION char_else VALUES LESS THAN MAXVALUE
);
create index idx_part_t3 on part_t3(NVL(a,'a'), b);
select /*+ RECOMPILE */* from part_t3 where NVL(a,'a')='a' using index idx_part_t3(+);


-- partition table - NVL2()
create table part_t4(
    a char(1), b short
) PARTITION BY RANGE (a) (
    PARTITION less_c VALUES LESS THAN ('c'),
    PARTITION char_else VALUES LESS THAN MAXVALUE
);
create index idx_part_t4 on part_t4(NVL2(a,'a','z'), b);
select /*+ RECOMPILE */* from part_t4 where NVL2(a,'a','z')='a' using index idx_part_t4(+);


drop t1, t2, t3, t4;
drop view_t1, view_t2, view_t3, view_t4;
drop part_t1, part_t2, part_t3, part_t4;
