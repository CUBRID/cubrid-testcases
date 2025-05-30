
set names utf8 collate utf8_en_cs;
prepare stmt from 'select NULLIF(?, ?),  collation (NULLIF(?, ?))'; 

execute stmt using _utf8'A', _utf8'a', _utf8'A', _utf8'a';

execute stmt using _euckr'A', _euckr'a', _euckr'A', _euckr'a';
execute stmt using _euckr'A', _utf8'a', _euckr'A', _utf8'a';
deallocate prepare stmt;

drop table if exists t1;
create table t1 (s1 string collate utf8_en_ci,s2 int);
insert into t1 values('a',1);
insert into t1 values('A',2);

prepare stmt from 'select NULLIF(s1, ?), collation (NULLIF(s1, ?)) from t1 order by s2'; 
execute stmt using _utf8'a', _utf8'a';
execute stmt using _iso88591'a', _iso88591'a';
execute stmt using _euckr'a', _euckr'a';
execute stmt using _utf8'x', _utf8'x';
execute stmt using _euckr'x', _euckr'x';
execute stmt using _iso88591'x', _iso88591'x';
deallocate prepare stmt;

drop table t1;

set names iso88591;


