--+ holdcas on;
set names iso88591;

drop table if exists t;
create table t(s1 char(10) collate utf8_en_ci, s2 enum('ab', 'Ab', 'AB', 'aB') collate iso88591_en_cs);
insert into t values('aB', 1);
insert into t values('Ab', 'aB');

--compare with constant
prepare st1 from 'select * from t where ? like ? order by 1, 2';
execute st1 using 'abc', 'A%';
set names iso88591 collate iso88591_en_ci;
execute st1 using 'ABc', 'ab%';
set names utf8 collate utf8_en_cs;
execute st1 using 'AaB', 'a%';

execute st1 using _iso88591'abC', 'A%';
execute st1 using 'abC', _euckr'a%';
deallocate prepare st1;


--with subquery
prepare st1 from 'select * from t where ? like (select ? from db_root) order by 1, 2';
execute st1 using 'abc', 'A%';
set names iso88591 collate iso88591_en_ci;
execute st1 using 'ABc', 'ab%';
set names utf8 collate utf8_en_cs;
execute st1 using 'AaB', 'a%';

execute st1 using _iso88591'abC', 'A%';
execute st1 using 'abC', _euckr'a%';


--compare with s1
prepare st2 from 'select * from t where s1 like ?+? order by 1, 2';
execute st2 using 'a', 'b';
set names utf8 collate utf8_en_ci;
execute st2 using 'A', 'B';
set names utf8 collate utf8_en_cs;
execute st2 using 'A', 'b';
set names euckr;
execute st2 using 'a', 'B';

execute st2 using _iso88591'a', 'b';
execute st2 using _euckr'A', _utf8'b';
deallocate prepare st2;

--compare with s2
prepare st3 from 'select * from t where s2 like ?+? order by 1, 2';
execute st3 using 'a', 'b';
set names utf8 collate utf8_en_ci;
execute st3 using 'A', 'B';
set names utf8 collate utf8_en_cs;
execute st3 using 'A', 'b';
set names euckr;
execute st3 using 'a', 'B';

execute st3 using _iso88591'a', 'b';
execute st3 using _euckr'A', _utf8'B';
deallocate prepare st3;


--session variable
set @a1='a%' collate utf8_en_cs;
set @a2='A%' collate utf8_en_ci;
set @b1='Ab' collate utf8_en_cs;
set @b2='%B' collate iso88591_en_ci;

set names iso88591;
execute st1 using 'aBB', @a1;
execute st1 using 'AB', @b2;
--BUG CUBRIDSUS-13629, already resolved
execute st1 using @b1, @a2;

prepare st2 from 'select * from t where s1 like ? order by 1, 2';
set names utf8;
execute st2 using @a1;
execute st2 using @b1;

prepare st3 from 'select * from t where s2 like ? order by 1, 2';
set names euckr;
execute st3 using @b2;
execute st3 using @a2;


drop variable @a1, @a2, @b1, @b2;

deallocate prepare st1;
deallocate prepare st2;
deallocate prepare st3;

drop table t;

set names iso88591;

--+ holdcas off;
