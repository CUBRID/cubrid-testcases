-- CBRD-24563 : default regexp library change from cppstd to RE2
set system parameters 'regexp_engine=cppstd';

-- regular expression tests (constant folding)
select (null rlike 'a');
select ('a' rlike null);
select (null rlike null);

select ('' rlike 'a');
select ('a' rlike '');
select ('' rlike '');

select (null rlike '');
select ('' rlike null);

select ('a' rlike '^a$'), ('b' rlike '^a$');
select ('' rlike '^a*$'), ('aaa' rlike '^a*$'), ('baa' rlike '^a*$');
select ('a' rlike '^a+$'), ('aaa' rlike '^a+$'), ('' rlike '^a+$');
select ('' rlike '^a?$'), ('a' rlike '^a?$'), ('aa' rlike '^a?$');
select ('abbaababab' rlike '^(ab|ba)*$'), ('abb' rlike '^(ab|ba)*$');
select ('aaa' rlike '^a{3,5}$'), ('aaaaa' rlike '^a{3,5}$'), ('aa' rlike '^a{3,5}$');
select ('abcbabababc' rlike '^[abc]+$'), ('a' rlike '^[abc]+$'), ('abcdbcbcbabc' rlike '^[abc]+$');
select ('abcxacbxax' rlike '^[a-cx]+$'), ('xxaba' rlike '^[a-cx]+$'), ('dabcx' rlike '^[a-cx]+$');
select ('xyz' rlike '^[^a-w]*$'), ('xyz123!@#' rlike '^[^a-w]*$'), ('wxyz' rlike '^[^a-w]*$');
select ('~' rlike '^[[.tilde.]]$'), ('a' rlike '^[[.tilde.]]$');
select ('a fox is cute' rlike '\bfox\b'), ('a foxx is cute' rlike '\bfox\b');
