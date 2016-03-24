--+ holdcas on;

set names iso88591;

prepare s1 from 'select trim (?), collation (trim (?))';
prepare s2 from 'select ltrim (?), collation (ltrim (?))';
prepare s3 from 'select rtrim (?), collation (rtrim (?))';
prepare s4 from 'select lpad (?, ?), collation (lpad (?, ?))';
prepare s5 from 'select rpad (?, ?), collation (rpad (?, ?))';
prepare s6 from 'select replace (?, ?), collation (replace (?, ?))';

set names iso88591 collate iso88591_en_cs;

execute s1 using '    a    ', '    a    ';
execute s2 using '    a    ', '    a    ';
execute s3 using '    a    ', '    a    ';
execute s4 using 'a', 10, 'a', 10;
execute s5 using 'a', 10, 'a', 10;
execute s6 using 'ab', 'b', 'a', 10;

set names iso88591 collate iso88591_en_ci;

execute s1 using '    a    ', '    a    ';
execute s2 using '    a    ', '    a    ';
execute s3 using '    a    ', '    a    ';
execute s4 using 'a', 10, 'a', 10;
execute s5 using 'a', 10, 'a', 10;
execute s6 using 'ab', 'b', 'a', 10;

set names utf8 collate utf8_en_cs;

execute s1 using '    a    ', '    a    ';
execute s2 using '    a    ', '    a    ';
execute s3 using '    a    ', '    a    ';
execute s4 using 'a', 10, 'a', 10;
execute s5 using 'a', 10, 'a', 10;
execute s6 using 'ab', 'b', 'a', 10;

set names utf8 collate utf8_en_ci;

execute s1 using '    a    ', '    a    ';
execute s2 using '    a    ', '    a    ';
execute s3 using '    a    ', '    a    ';
execute s4 using 'a', 10, 'a', 10;
execute s5 using 'a', 10, 'a', 10;
execute s6 using 'ab', 'b', 'a', 10;

set names euckr collate euckr_bin;

execute s1 using '    a    ', '    a    ';
execute s2 using '    a    ', '    a    ';
execute s3 using '    a    ', '    a    ';
execute s4 using 'a', 10, 'a', 10;
execute s5 using 'a', 10, 'a', 10;
execute s6 using 'ab', 'b', 'a', 10;

deallocate prepare s1;
deallocate prepare s2;
deallocate prepare s3;
deallocate prepare s4;
deallocate prepare s5;
deallocate prepare s6;

set names iso88591;
