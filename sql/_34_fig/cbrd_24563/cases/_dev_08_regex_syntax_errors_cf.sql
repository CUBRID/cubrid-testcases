-- CBRD-24563 : default regexp library change from cppstd to RE2
set system parameters 'regexp_engine=re2';

-- regular expression syntax errors
select ('' rlike 'a{5,3}');
select ('' rlike '((a)');

set system parameters 'regexp_engine=default';

