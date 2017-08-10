set names iso88591;

prepare st1 from 'select /*+ recompile */ decode(?, ''a'', ?)';
execute st1 using 'a', 'Y';
set names iso88591 collate iso88591_en_ci;
execute st1 using 'A', 'Y';
set names utf8 collate utf8_en_cs;
execute st1 using 'A', 'Y';

execute st1 using _iso88591'a', 'Y';
execute st1 using 'A', _euckr'Y';


prepare st2 from 'select decode(?, ?, ?)';
execute st2 using 'A', 'a', 'Y';
set names iso88591 collate iso88591_en_ci;
execute st2 using 'a', 'A', 'Y';
set names utf8 collate utf8_en_cs;
execute st2 using 'A', 'A', 'Y';

execute st2 using 'A', _iso88591'a', 'Y';
execute st2 using 'a', 'A', _euckr'Y';


drop table if exists t;
create table t(s1 char(10) collate utf8_en_ci, s2 enum('a', 'A', 'b', 'B') collate iso88591_en_cs);
insert into t values('a', 1);
insert into t values('A', 'B');
insert into t values(null, null);

--compare with s1
prepare st3 from 'select s1, decode(s1, ?, ?, NVL(?, s2), ?) from t order by 1, 2';
execute st3 using 'a', 'Y', 'A', 'N';
set names iso88591 collate iso88591_en_ci;
execute st3 using 'A', 'Y', 'a', 'N';
set names utf8 collate utf8_en_cs;
execute st3 using 'A', 'Y', null, 'N';

execute st3 using _euckr'a', _iso88591'Y', null, 'N';
execute st3 using 'A', _euckr'Y', _iso88591'a', _euckr'N';

--compare with s2
prepare st4 from 'select s2, decode(s2, ?, ?, NVL(?, s1), ?) from t order by 1, 2';
execute st4 using 'a', 'Y', 'b', 'N';
set names iso88591 collate iso88591_en_ci;
execute st4 using 'A', 'Y', 'b', 'N';
set names utf8 collate utf8_en_cs;
execute st4 using null, 'Y', null, 'N';

execute st4 using _iso88591'a', 'Y', _euckr'B', 'N';
execute st4 using 'B', _utf8'Y', null, _euckr'N';

--session variable
set @a1='a' collate utf8_en_cs;
set @a2='Y' collate utf8_en_ci;
set @b1='b' collate utf8_en_cs;
set @b2='N' collate iso88591_en_ci;

set names iso88591;
execute st1 using @a1, 'Y';
execute st1 using @b1, @a2;
execute st1 using @a1, 'Y';

set names utf8;
execute st2 using 'a', @a1, _iso88591'Y';
execute st2 using @a2, _euckr'Y', @b2;

set names euckr;
execute st3 using 'a', _iso88591'Y', @b1, @b2;
execute st3 using @a2, _euckr'Y', @b1, _iso88591'N';

set names utf8 collate utf8_en_ci;
execute st4 using null, @a2, 'a', @b2;
execute st4 using @b2, null, null, @b2;

drop variable @a1, @a2, @b1, @b2;
deallocate prepare st1;
deallocate prepare st2;
deallocate prepare st3;
deallocate prepare st4;

drop table t;

set names iso88591;
