/**
 *  This test case verifies CBRD-27510: LPAD, RPAD and SUBSTRING_INDEX over strings whose collations resolve_domains
 *  resolves (session variables) take the source string's collation, as db_string_pad and db_string_substring_index
 *  make their results; SUBSTRING_INDEX rejects a delimiter whose collation does not merge with the source's
 *  (-1150, ER_QSTR_INCOMPATIBLE_COLLATIONS), LPAD and RPAD read the pad string's collation not at all.
 *
 *  Before the fix the resolved collation was the merge of every argument (the rule of CONCAT and REPLACE): a
 *  comparison of two padded strings used the pad string's case-insensitive collation while the values carried the
 *  source's, and a pad string whose collation does not merge left the node without a domain (-1383).
 *
 *  Coverage:
 *    Case 1: LPAD / RPAD / SUBSTRING_INDEX over session variables: comparison, DISTINCT, COLLATION ()
 *    Case 2: a pad string or delimiter whose collation does not merge with the source's
 *    Case 3: the operators that merge (CONCAT, REPLACE, INSERT, TRIM) and a literal source
 */
--+ holdcas on;
set @a = 'abc';
set @c = 'ABC';
set @b = _utf8'*' collate utf8_en_ci;

-- Case 1. The source string's collation.
evaluate 'Case 1: LPAD, RPAD, SUBSTRING_INDEX take the source collation';
select lpad(@a, 5, @b) = lpad(@c, 5, @b), rpad(@a, 5, @b) = rpad(@c, 5, @b) from db_root;
select count(distinct x) from (select lpad(@a, 5, @b) x from db_root union all select lpad(@c, 5, @b) from db_root) t;
select substring_index(@a, @b, 1) = substring_index(@c, @b, 1) from db_root;
select collation(lpad(@a, 5, @b)), collation(rpad(@a, 5, @b)), collation(substring_index(@a, @b, 1)) from db_root;
select lpad(@a, 5, @b), rpad(@a, 5, @b), substring_index(@a, @b, 1) from db_root;

-- Case 2. A collation that does not merge with the source's.
evaluate 'Case 2: a pad string or delimiter whose collation does not merge';
set @x = _utf8'abc' collate utf8_en_cs;
set @y = _utf8'*' collate utf8_en_ci;
select lpad(@x, 5, @y), rpad(@x, 5, @y) from db_root;
select substring_index(@x, @y, 1) from db_root;

-- Case 3. The operators that merge, and a literal source.
evaluate 'Case 3: the operators that merge';
select insert(@a, 2, 1, @b) = insert(@c, 2, 1, @b), collation(insert(@a, 2, 1, @b)) from db_root;
select insert(@x, 2, 1, @y) from db_root;
select lpad('abc', 5, @b) = lpad('ABC', 5, @b), trim(@b from @a) = trim(@b from @c), replace(@a, 'b', @b) = replace(@c, 'B', @b) from db_root;
deallocate variable @a, @c, @b, @x, @y;
--+ holdcas off;
