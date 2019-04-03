--#1
select ('a word file' regexp '\bWord\b');
select ('__pa word _file' regexp '\bWord\b');
select ('__pa  word  _file' regexp '\bWord\b');
select ('__pa  word _file' regexp '\bWord\b');
select ('__pa wrd  _file' regexp '\bWo?rd\b');
select ('__pa 7_1 _file' regexp '\b[^_a-z09]_[0-1]\b');

--#0
select ('a word file' regexp binary '\bWord\b');
select ('__pa wordddd _file' regexp '\bWord{2,3}\b');
select ('__pa a _file' regexp '\b[^a-z]\b');
select ('__pa _1 _file' regexp '\b[^_a-z09][0-1]\b');
select ('__pa 71 _file' regexp '\b[^_a-z09]_[0-1]\b');
