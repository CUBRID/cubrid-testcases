--+ holdcas on;
set names binary;
SELECT FIND_IN_SET('中','我,我们,中国,中');
SELECT FIND_IN_SET(' ','我, ,中,中国');
SELECT FIND_IN_SET('','我,中,中国,');

-- different charset
set names iso88591;
SELECT FIND_IN_SET(_utf8'中','我,我们,中,中国');        
set names binary;
SELECT FIND_IN_SET(_utf8'中','我,我们,中,中国');
SELECT FIND_IN_SET('中',cast(_utf8'我,我们,中,中国' as string charset euckr));

-- prepare clause
prepare st1 from 'select find_in_set(?, ?)';
set names binary;
execute st1 using '이상', '설치,이상치,이상';
execute st1 using _utf8'abc', 'abc';
drop prepare st1;

set names utf8;
drop table if exists t1;
create table t1 (col1 char(30) collate binary, col2 varchar(20), col3 string collate euckr_bin);
insert into t1 values('中国,我,中,我们','中国,我,中,我们','최신,확장,라');

SELECT FIND_IN_SET('中',col1) from t1;
SELECT FIND_IN_SET('我',col2) from t1;
SELECT FIND_IN_SET(_binary'我',col2) from t1;
SELECT FIND_IN_SET(_binary'라',col3) from t1;

-- prepare clause
set @a=cast( _utf8'확장' as string charset euckr);
prepare st1 from 'select find_in_set(?, col1) from t1';
prepare st2 from 'select find_in_set(?, col2) from t1';
prepare st3 from 'select find_in_set(?, col3) from t1';
prepare st3 from 'select ?';
set names binary;
execute st1 using '我';
execute st2 using '我';
execute st3 using @a;
drop prepare st1;
drop prepare st2;
drop prepare st3;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;