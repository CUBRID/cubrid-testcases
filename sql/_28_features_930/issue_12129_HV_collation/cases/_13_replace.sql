--+ holdcas on;
set names iso88591;

--compare with constant
prepare st1 from 'select replace(?, ?, ?);';
execute st1 using 'helloAaAAaaAA', 'a', 'b';
set names iso88591 collate iso88591_en_ci;
execute st1 using 'helloAaaAAaa', 'a', 'Bb';
set names utf8 collate utf8_en_cs;
execute st1 using 'helloAaaAAaa', 'a', 'Bb';

execute st1 using _iso88591'helloaAaAaa', 'A', 'b';
execute st1 using 'helloAaAaaAA', _euckr'A', _euckr'b';



drop table if exists t;
create table t(s1 char(10) collate utf8_en_ci, s2 enum('a', 'A', 'b', 'B') collate iso88591_en_cs);
insert into t values('a', 1);
insert into t values('A', 2);

--compare with s1
prepare st2 from 'select replace(?, trim(s1), ?), collation(replace(?, trim(s1), ?)) from t order by 1, 2';
execute st2 using 'helloAaaAAaa', 'b', 'helloAaaAAaa', 'b';
set names utf8 collate utf8_en_ci;
execute st2 using 'helloAaaAAaa', 'B', 'helloAaaAAaa', 'B';
set names utf8 collate utf8_en_cs;
execute st2 using 'helloAaAAaaAA', 'b', 'helloAaAAaaAA', 'b';
set names euckr;
execute st2 using 'helloAaAAaaAA', 'B', 'helloAaAAaaAA', 'B';

execute st2 using _iso88591'helloAaAAaaAA', 'b', _iso88591'helloAaAAaaAA', 'b';
execute st2 using _euckr'helloAaAAaaAA', _utf8'B', _euckr'helloAaAAaaAA', _utf8'B';


--compare with s2
prepare st3 from 'select replace(?, s2, ?), collation(replace(?, s2, ?)) from t order by 1, 2';
execute st3 using 'helloAaaAAaa', 'b', 'helloAaaAAaa', 'b';
set names utf8 collate utf8_en_ci;
execute st3 using 'helloAaaAAaa', 'B', 'helloAaaAAaa', 'B';
set names utf8 collate utf8_en_cs;
execute st3 using 'helloAaAAaaAA', 'b', 'helloAaAAaaAA', 'b';
set names euckr;
execute st3 using 'helloAaAAaaAA', 'B', 'helloAaAAaaAA', 'b';

execute st3 using _iso88591'helloAaAAaaAA', 'b', _iso88591'helloAaAAaaAA', 'b';
execute st3 using _euckr'helloAaAAaaAA', _utf8'B', _euckr'helloAaAAaaAA', _utf8'B';

--session variable
set @a1='a' collate utf8_en_cs;
set @a2='A' collate utf8_en_ci;
set @b1='b' collate utf8_en_cs;
set @b2='B' collate iso88591_en_ci;

set names iso88591;
execute st1 using _utf8'helloAaaaAA', @a1, @b1;
execute st1 using 'helloAaaaAA', @a2, 'b';
execute st1 using _utf8'helloAaaaAA', @a1, @b2;

set names utf8;
execute st2 using _iso88591'helloAaaaAA', @b2, _iso88591'helloAaaaAA', @b2;
execute st2 using @a2, @b1, @a2, @b1;

set names euckr;
execute st3 using _utf8'helloAaaaAA', @b2, _utf8'helloAaaaAA', @b2;
execute st3 using @a2, @b1, @a2, @b1;


drop variable @a1, @a2, @b1, @b2;
deallocate prepare st1;
deallocate prepare st2;
deallocate prepare st3;

drop table t;

set names iso88591;

--+ holdcas off;
