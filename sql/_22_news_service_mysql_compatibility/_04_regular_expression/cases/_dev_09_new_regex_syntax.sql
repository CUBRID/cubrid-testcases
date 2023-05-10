-- CBRD-24563 : default regexp library change from cppstd to RE2
set system parameters 'regexp_engine=cppstd';

-- backslash escapes a metacharacter
select ('^' rlike '[\^\]]');
select (']' rlike '[\^\]]');

-- POSIX shorthand class
select ('   ' rlike '[[:s:][:d:]]');
select (' '   rlike '[[:s:][:d:]]');
select ('1'   rlike '[[:s:][:d:]]');

select ('word' rlike '[[:w:]]');

-- shorthands
select ('a' rlike '\w');
select ('a' rlike '[\w]');
select ('a' rlike '[\W]');

select ('1' rlike '\d');
select ('1' rlike '[\d]');

select (' ' rlike '\s');
select ('   ' rlike '\s');

select (' ' rlike '[\s]');
select ('   ' rlike '[\s]');

-- quantifiers
select ('ab' rlike 'abc??');
select ('abc' rlike 'abc??');

-- non-capturing group
select ('abcabcabc' rlike '(?:abc){3}');

-- special groups (positive, negative lookahead)
select ('streets' rlike 't(?=s)');
select ('street'  rlike 't(?=s)');

select ('streets' rlike 't(?!s)');
select ('sports'  rlike 't(?!s)');

set system parameters 'regexp_engine=default';

