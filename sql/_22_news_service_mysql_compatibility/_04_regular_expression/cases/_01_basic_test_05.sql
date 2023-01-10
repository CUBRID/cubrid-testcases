-- CBRD-24563 : default regexp library change from cppstd to RE2
set system parameters 'regexp_engine=cppstd';

-- POSIX-style word boundary does not support
select ('a word file' regexp '[[:<:]]word[[:>:]]');

-- Tests for ECMAScrpt word boundary syntax 
select ('a word file' regexp '\bWord\b');
select ('__pa word _file' regexp '\bWord\b');
select ('__pa  word  _file' regexp '\bWord\b');
select ('__pa  word _file' regexp '\bWord\b');
select ('__pa wrd  _file' regexp '\bWo?rd\b');
select ('__pa 7_1 _file' regexp '\b[^_a-z09]_[0-1]\b');

select ('a word file' regexp binary '\bWord\b');
select ('__pa wordddd _file' regexp '\bWord{2,3}\b');
select ('__pa a _file' regexp '\b[^a-z]\b');
select ('__pa _1 _file' regexp '\b[^_a-z09][0-1]\b');
select ('__pa 71 _file' regexp '\b[^_a-z09]_[0-1]\b');

set system parameters 'regexp_engine=default';

