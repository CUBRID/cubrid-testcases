set names iso88591;

--compare with constant
prepare st1 from 'select substring_index(?, ?, ?);';
execute st1 using 'helloAaAAaaAA', 'a', 1;
set names iso88591 collate iso88591_en_ci;
execute st1 using 'helloAaaAAaa', 'a', 2;
set names utf8 collate utf8_en_cs;
execute st1 using 'helloAaaAAaa', 'a', 3;

execute st1 using _iso88591'helloaAaAaa', 'A', '4';
execute st1 using 'helloAaAaaAA', _euckr'A', _euckr'2';



drop table if exists t;
create table t(s1 char(10) collate utf8_en_ci, s2 enum('a', 'A', 'b', 'B') collate iso88591_en_cs);
insert into t values('a', 1);
insert into t values('A', 2);

--compare with s1
prepare st2 from 'select substring_index(?, trim(s1), ?), collation(substring_index(?, trim(s1), ?)) from t order by 1, 2';
execute st2 using 'helloAaaAAaa', '1', 'helloAaaAAaa', '1';
set names utf8 collate utf8_en_ci;
execute st2 using 'helloAaaAAaa', '2', 'helloAaaAAaa', '2';
set names utf8 collate utf8_en_cs;
execute st2 using 'helloAaAAaaAA', '3', 'helloAaAAaaAA', '3';
set names euckr;
execute st2 using 'helloAaAAaaAA', '4', 'helloAaAAaaAA', '4';

execute st2 using _iso88591'helloAaAAaaAA', '5', _iso88591'helloAaAAaaAA', '5';
execute st2 using _euckr'helloAaAAaaAA', _utf8'8', _euckr'helloAaAAaaAA', _utf8'8';


--compare with s2
prepare st3 from 'select substring_index(?, s2, ?), collation(substring_index(?, s2, ?)) from t order by 1, 2';
execute st3 using 'helloAaaAAaa', '1', 'helloAaaAAaa', '1';
set names utf8 collate utf8_en_ci;
execute st3 using 'helloAaaAAaa', '2', 'helloAaaAAaa', '2';
set names utf8 collate utf8_en_cs;
execute st3 using 'helloAaAAaaAA', '3', 'helloAaAAaaAA', '3';
set names euckr;
execute st3 using 'helloAaAAaaAA', '4', 'helloAaAAaaAA', '4';

execute st3 using _iso88591'helloAaAAaaAA', '5', _iso88591'helloAaAAaaAA', '5';
execute st3 using _euckr'helloAaAAaaAA', _utf8'6', _euckr'helloAaAAaaAA', _utf8'6';

--session variable
set @a1='a' collate utf8_en_cs;
set @a2='A' collate utf8_en_ci;
set @b1='a' collate iso88591_en_cs;
set @b2='A' collate iso88591_en_ci;
set @num1=5;
set @num2='3' collate utf8_en_ci;

set names iso88591;
execute st1 using _utf8'helloAaaaAA', @a1, 1;
execute st1 using 'helloAaaaAA', @a2, '2';
execute st1 using _utf8'helloAaaaAA', @a1, @num1;

set names utf8;
execute st2 using _iso88591'helloAaaaAA', @num2, _iso88591'helloAaaaAA', @num2;
execute st2 using @a2, @num1, @a2, @num1;

set names euckr;
execute st3 using _utf8'helloAaaaAA', @num1, _utf8'helloAaaaAA', @num1;
execute st3 using @a2, @num2, @a2, @num2;


drop variable @a1, @a2, @b1, @b2, @num1, @num2;
deallocate prepare st1;
deallocate prepare st2;
deallocate prepare st3;

drop table t;

set names iso88591;
