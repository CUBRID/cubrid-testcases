--+ holdcas on;
set names iso88591;

--compare with constant
prepare st1 from 'select find_in_set(?, ?)';
execute st1 using 'ab','AB,aB,ab,Ab';
set names iso88591 collate iso88591_en_ci;
execute st1 using 'ABc','abc,AbC,aBc,ABc,ABC';
set names utf8 collate utf8_en_cs;
execute st1 using 'AaB','a,ab,aab,AAb,AaB,aAB';

--BUG CUBRIDSUS-13647
execute st1 using _iso88591'ABc','abc,AbC,aBc,ABc,ABC';
execute st1 using 'AaB',_euckr'a,ab,aab,AAb,AaB,aAB';
deallocate prepare st1;

--with subquery
prepare st1 from 'select find_in_set(?, (select ? from db_root))';
execute st1 using 'ab','AB,aB,ab,Ab';
set names iso88591 collate iso88591_en_ci;
execute st1 using 'ABc','abc,AbC,aBc,ABc,ABC';
set names utf8 collate utf8_en_cs;
execute st1 using 'AaB','a,ab,aab,AAb,AaB,aAB';

execute st1 using _iso88591'ABc','abc,AbC,aBc,ABc,ABC';
execute st1 using 'AaB',_euckr'a,ab,aab,AAb,AaB,aAB';


drop table if exists t;
create table t(s1 varchar(10) collate utf8_en_ci, s2 enum('ab', 'Ab', 'AB', 'aB') collate iso88591_en_cs);
insert into t values('aB', 1);
insert into t values('Ab', 'aB');


--compare with s1
prepare st2 from 'select s1, find_in_set(s1, ?+?), hex(s1) from t order by 1, 2, 3';
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
prepare st3 from 'select s2, find_in_set(s2, ?+?) from t order by 1, 2';
execute st3 using 'a', 'b';
set names utf8 collate utf8_en_ci;
execute st3 using 'A', 'B';
set names utf8 collate utf8_en_cs;
execute st3 using 'A', 'b';
set names euckr;
execute st3 using 'a', 'B';

execute st3 using _iso88591'a', 'b';
execute st3 using _euckr'A', _euckr'B';
deallocate prepare st3;


--session variable
set @a1='aB' collate utf8_en_cs;
set @a2='Ab' collate utf8_en_ci;
set @b1='Ab' collate utf8_en_cs;
set @b2='B' collate iso88591_en_ci;

set names iso88591;
execute st1 using 'a', @a1;
execute st1 using _utf8'Ab', @b2;
execute st1 using _utf8'Ab', @a2;
execute st1 using @b1, @a2;

prepare st2 from 'select find_in_set(s1, ?) from t order by 1';
set names utf8;
execute st2 using @a1;
execute st2 using @b1;

prepare st3 from 'select find_in_set(s2, ?) from t order by 1';
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
