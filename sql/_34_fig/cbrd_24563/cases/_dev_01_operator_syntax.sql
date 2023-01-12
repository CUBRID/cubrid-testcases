-- CBRD-24563 : default regexp library change from cppstd to RE2
set system parameters 'regexp_engine=re2';

-- operator syntax test
select ('abc' rlike             'abc'), ('ABC' rlike             'abc');
select ('abc' regexp            'abc'), ('ABC' regexp            'abc');
select ('abc' not rlike         'abc'), ('ABC' not rlike         'abc');
select ('abc' not regexp        'abc'), ('ABC' not regexp        'abc');
select ('abc' rlike binary      'abc'), ('ABC' rlike binary      'abc');
select ('abc' regexp binary     'abc'), ('ABC' regexp binary     'abc');
select ('abc' not rlike binary  'abc'), ('ABC' not rlike binary  'abc');
select ('abc' not regexp binary 'abc'), ('ABC' not regexp binary 'abc');

set system parameters 'regexp_engine=default';

