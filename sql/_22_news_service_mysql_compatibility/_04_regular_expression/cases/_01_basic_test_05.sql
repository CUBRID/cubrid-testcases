--#1
select ('a word file' regexp '[[:<:]]Word[[:>:]]');
select ('__pa word _file' regexp '[[:<:]]Word[[:>:]]');
select ('__pa  word  _file' regexp '[[:<:]]Word[[:>:]]');
select ('__pa  word _file' regexp '[[:<:]]Word[[:>:]]');
select ('__pa wrd  _file' regexp '[[:<:]]Wo?rd[[:>:]]');
select ('__pa 7_1 _file' regexp '[[:<:]][^_a-z09]_[0-1][[:>:]]');

--#0
select ('a word file' regexp binary '[[:<:]]Word[[:>:]]');
select ('__pa wordddd _file' regexp '[[:<:]]Word{2,3}[[:>:]]');
select ('__pa a _file' regexp '[[:<:]][^a-z][[:>:]]');
select ('__pa _1 _file' regexp '[[:<:]][^_a-z09][0-1][[:>:]]');
select ('__pa 71 _file' regexp '[[:<:]][^_a-z09]_[0-1][[:>:]]');
