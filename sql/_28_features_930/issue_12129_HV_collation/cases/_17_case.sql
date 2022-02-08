--+ holdcas on;
set names iso88591;

prepare st1 from 'select /*+ recompile */ case when ?=''a'' then ? else ? end';
execute st1 using 'a', 'Y', 'N';
set names iso88591 collate iso88591_en_ci;
execute st1 using 'A', 'Y', 'N';
set names utf8 collate utf8_en_cs;
execute st1 using 'A', 'Y', 'N';

execute st1 using _iso88591'a', 'Y', 'N';
execute st1 using 'A', _euckr'Y', _euckr'N';


prepare st2 from 'select case when ?=? then ? else ? end';
execute st2 using 'A', 'a', 'Y', 'N';
set names iso88591 collate iso88591_en_ci;
execute st2 using 'a', 'A', 'Y', 'N';
set names utf8 collate utf8_en_cs;
execute st2 using 'A', 'A', 'Y', 'N';

execute st2 using 'A', _iso88591'a', 'Y', 'N';
execute st2 using 'a', 'A', _euckr'Y', _euckr'N';


drop table if exists t;
create table t(s1 char(10) collate utf8_en_ci, s2 enum('a', 'A', 'b', 'B') collate iso88591_en_cs);
insert into t values('a', 1);
insert into t values('A', 'B');
insert into t values(null, null);

--compare with s1
prepare st3 from 'select s1, case when isnull(ifnull(s1, ?))<>0 then ? else ? end from t order by 1, 2';
execute st3 using 'a', 'Y', 'N';
set names iso88591 collate iso88591_en_ci;
execute st3 using null, 'Y', 'N';
set names utf8 collate utf8_en_cs;
execute st3 using 'A', 'Y', 'N';

execute st3 using null, _iso88591'Y', 'N';
execute st3 using 'A', _euckr'Y', _euckr'N';

--compare with s2
prepare st4 from 'select s2, case when isnull(ifnull(s2, ?))<>0 then ? else ? end from t order by 1, 2';
execute st4 using 'a', 'Y', 'N';
set names iso88591 collate iso88591_en_ci;
execute st4 using 'A', 'Y', 'N';
set names utf8 collate utf8_en_cs;
execute st4 using null, 'Y', 'N';

execute st4 using _iso88591'a', 'Y', 'N';
execute st4 using null, _utf8'Y', _euckr'N';

--session variable
set @a1='Y' collate utf8_en_cs;
set @a2='Y' collate utf8_en_ci;
set @b1='N' collate utf8_en_cs;
set @b2='N' collate iso88591_en_ci;

set names iso88591;
execute st1 using @a1, 'Y', @b1;
execute st1 using @b2, @a2, 'N';
execute st1 using @b2, 'Y', 'N';

set names utf8;
execute st2 using 'a', _iso88591'a', @a1, @b2;
execute st2 using _euckr'ABC', _euckr'abc', @a2, @b1;

set names euckr;
execute st3 using @a2, @a1, @b2;
execute st3 using @b2, @a2, @b1;

set names utf8 collate utf8_en_ci;
execute st4 using null, @a1, @b2;
execute st4 using @b2, @a2, @b1;

drop variable @a1, @a2, @b1, @b2;
deallocate prepare st1;
deallocate prepare st2;
deallocate prepare st3;
deallocate prepare st4;

drop table t;

set names iso88591;

--+ holdcas off;
