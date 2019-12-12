--+ holdcas on;
set names binary;

SELECT POSITION ('' IN '12345abcdeabcde');
SELECT POSITION ('abcd' IN '12345abcdeabcde');
SELECT POSITION ('나' IN '12345가나다라마가나다라마'),cast(_utf8'나' as string charset binary),cast(_utf8'12345가나다라마가나다라마' as string charset binary) ;
SELECT POSITION ('f' IN '12345abcdeabcde');
----CUBRIDSUS-17847
SELECT POSITION (B'1' IN B'000011110000');
SELECT POSITION ('中国' IN '中国人民共和国'), cast(_utf8'中国' as string charset binary), cast(_utf8'中国人民共和国' as string charset binary);

set names utf8;
drop table if exists a;
create table t (col_binary varchar(100) collate binary, col_euckr varchar(100) collate euckr_bin, col_utf8 varchar(100) collate utf8_bin, col_iso varchar(100) collate iso88591_bin);
insert into t values ('12345abcdeabcde', '12345abcdeabcde', '12345abcdeabcde', '12345abcdeabcde');
insert into t values ('12345가나다라마가나다라마', '12345가나다라마가나다라마', '12345가나다라마가나다라마', '12345가나다라마가나다라마');
insert into t values ('000011110000', '000011110000', '000011110000', '000011110000');
insert into t values ('中国人民共和国', '中国人民共和国', '中国人民共和国', '中国人民共和国');

set names binary;
select * from t order by 1;
select col_binary, position('' in col_binary) from t order by 1;
select col_binary, position('' in col_euckr) from t order by 1;
select col_binary, position('' in col_utf8) from t order by 1;
select col_binary, position('' in col_iso) from t order by 1;
select col_binary, position('abcd' in col_binary), position('abcd' in col_euckr), position('abcd' in col_utf8), position('abcd' in col_iso) from t where col_binary like '%abcd%';
select col_binary, position('나' in col_binary), position('나' in col_euckr), position('나' in col_utf8), position('나' in col_iso)  from t where col_binary like '%나%';
select col_binary, position(cast(_utf8'나' as string charset binary) in col_binary), position(cast(_utf8'나' as string charset euckr) in col_euckr), position(_utf8'나' in col_utf8) from t where col_binary like '%나%';
select col_binary, position('f' in col_binary), position('f' in col_euckr), position('f' in col_utf8), position('f' in col_iso) from t order by 1;
select col_binary, position('1' in col_binary), position('1' in col_euckr), position('1' in col_utf8), position('1' in col_iso) from t where col_binary not like '%中国%'  order by 1;
select col_binary, position('中国' in col_binary), position('中国' in col_euckr), position('中国' in col_utf8), position('中国' in col_iso)  from t where col_binary  like '%中国%' ;
select col_binary, position(cast(_utf8'中国' as string charset binary) in col_binary), position(cast(_utf8'中国' as string charset euckr) in col_euckr), position(_utf8'中国' in col_utf8), position(cast(_utf8'中国' as string charset iso88591) in col_iso) from t where col_binary  like '%中国%' ;


drop table t;
set names iso88591;
--+ holdcas off;