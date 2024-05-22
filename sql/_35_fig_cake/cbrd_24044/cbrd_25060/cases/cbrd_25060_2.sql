-- This scenario is an extension of the initial CBRD-25060 tests and bug_bts_12615.sh.
-- Tests covered: explicitly created unique indexes (single & multi-column) and multi-column unique index joins.

drop table if exists tbl;

create table tbl (col_a varchar(20), col_b varchar(20), col_c varchar(20), col_d varchar(20), col_e numeric(20,10), col_f varchar(20), col_g varchar(20), col_h varchar(20));
insert into tbl select rownum, 1, mod(rownum,10), lpad(to_char(mod(rownum,100)),20,'0'), mod(rownum,1000), lpad(to_char(mod(rownum,10000)),20,'0'), lpad(to_char(mod(rownum,100000)),20,'0'), lpad(to_char(mod(rownum,100000)),20,'0') from db_class a, db_class b, db_class c, db_class d, db_class f, db_class g limit 10000;

set optimization level 513;
update statistics on tbl;

-- 1. Unique index prioritization in a single-column unique index scenario
    -- uidx_a: contains 1 unique index column (col_a) <- should be selected
    -- idx_b_c: contains 0 unique index columns, but covers more columns (b,c vs a)
create unique index uidx_a on tbl(col_a);
create index idx_b_c on tbl(col_b,col_c); 
--should prioritize unique index even if covers less columns
select /*+ recompile */ count(*) from tbl where col_a = 1 and col_b = 1 and col_c = 1;
drop index uidx_a on tbl;
drop index idx_b_c on tbl;
--pass: index: uidx_a term[0]

-- 2. Unique index prioritization in a multi-column unique index scenario: non-unique index does not include unique index column
    -- uidx_a_b: contains 2 unique index columns (col_a, col_b) <- should be selected
    -- idx_c_d_e: contains 0 unique index columns, but covers more columns (c,d,e vs a,b)
create unique index uidx_a_b on tbl(col_a, col_b);
create index idx_c_d_e on tbl(col_c,col_d,col_e); --does not contain any unique index
update statistics on tbl;

--should prioritize index with more unique indexes even if covers less columns
select /*+ recompile */ count(*) from tbl where col_a = 1 and col_b = 1 and col_c = 1 and col_d = 1 and col_e = 1;
-- pass: index: uidx_a_b term[0] AND term[4]

-- 3. Unique index prioritization in a multi-column unique index scenario: non-unique index includes unique index column
    -- uidx_a_b: contains 2 unique index columns (col_a, col_b) <- should be selected
    -- idx_b_c_d: contains 1 unique index column (col_b), but covers more columns (b,c,d vs a,b)
create index idx_b_c_d on tbl(col_b,col_c,col_d); --contains a unique index column (col_b)
update statistics on tbl;

--should prioritize index with more unique indexes even if covers less columns
select /*+ recompile */ count(*) from tbl where col_a = 1 and col_b = 1 and col_c = 1 and col_d = 1;
-- pass: index: uidx_a_b term[0] AND term[3]

-- 4. Non-unique index prioritization in a multi-column unique index scenario: non-unique index includes all unique index columns
    -- uidx_a_b: contains 2 unique index columns (col_a, col_b)
    -- idx_a_b_c: contains 2 unique index columns (col_a, col_b), and covers more columns (a,b,c vs a,b) <- should be selected
create index idx_a_b_c on tbl(col_a,col_b,col_c); --contains 2 unique index columns (col_a, col_b)
update statistics on tbl;

--should prioritize non-unique index because it contains the same amount of unique index columns and covers more columns
select /*+ recompile */ count(*) from tbl where col_a = 1 and col_b = 1 and col_c = 1;
-- pass: index: idx_a_b_c term[0] AND term[1] AND term[2] (covers)

-- 5. JOIN: Non-unique index prioritization in a multi-column unique index scenario: non-unique index includes all unique index columns
    -- uidx_a_b: contains 2 unique index columns (col_a, col_b)
    -- idx_a_b_c: contains 2 unique index columns (col_a, col_b), and covers more columns (a,b,c vs a,b) <- should be selected
select /*+ recompile ordered */ count(*) from tbl a, tbl b where a.col_a = b.col_a and a.col_b = b.col_b and a.col_c = b.col_c and a.col_d = b.col_d;

-- pass: index: idx_a_b_c term[0] AND term[1] AND term[3]

-- 6. JOIN: Unique index prioritization in a multi-column unique index scenario: non-unique index includes unique index columns
    -- uidx_a_b: contains 2 unique index columns (col_a, col_b) <- should be selected
    -- idx_b_c_d: contains 1 unique index column (col_b), but covers more columns (b,c,d vs a,b)
drop index idx_a_b_c on tbl;
update statistics on tbl;

select /*+ recompile ordered */ count(*) from tbl a, tbl b where a.col_a = b.col_a and a.col_b = b.col_b and a.col_c = b.col_c and a.col_d = b.col_d;

-- pass: index: uidx_a_b term[0] AND term[3]

-- 7. JOIN: Unique index prioritization in a multi-column unique index scenario: non-unique index includes unique index columns
    -- uidx_a_b: contains 2 unique index columns (col_a, col_b) <- should be selected
    -- idx_c_d_e: contains 0 unique index columns, but covers more columns (c,d,e vs a,b)
drop index idx_b_c_d on tbl;
update statistics on tbl;

select /*+ recompile ordered */ count(*) from tbl a, tbl b where a.col_a = b.col_a and a.col_b = b.col_b and a.col_c = b.col_c and a.col_d = b.col_d;

--pass: index: uidx_a_b term[0] AND term[3]

drop index idx_c_d_e on tbl;
 
drop table tbl;
