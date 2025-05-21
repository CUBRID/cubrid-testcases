set names iso88591;


prepare s from 'select TO_CHAR(?), collation (TO_CHAR(?))';
execute s using 'a','a';
execute s using _utf8'a',_utf8'a';

execute s using _euckr'a',_euckr'a';

set names utf8;
execute s using 'a','a';

set names euckr;
execute s using 'a','a';
deallocate prepare s;

set names iso88591;


