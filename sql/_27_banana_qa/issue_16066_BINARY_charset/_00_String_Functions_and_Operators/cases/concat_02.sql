--+ holdcas on;
set names utf8;
drop table if exists t1;
create table t1 (id int, col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values(1, '문자열', '문자열', '문자열', 'ÀÏ');
insert into t1 values(2, cast( _utf8'문자열' as string charset euckr), '문자열', '문자열', 'ÀÏ');
insert into t1 values(3, cast( _utf8'ÀÏ' as string charset iso88591), '문자열', '문자열', 'ÀÏ');
insert into t1 values(4, chr(0), chr(0), '문자열', chr(0));
create index i on t1(substring(col_binary,1,1));

-- CUBRIDSUS-17766
set names binary;
SELECT col_binary + col_euckr from t1 order by 1;
SELECT col_binary || col_utf8 from t1 order by 1;

--CUBRIDSUS-17824
SELECT concat(col_binary , col_iso) from t1 order by 1;

--CUBRIDSUS-17811
SELECT concat_ws(1, col_binary , col_euckr , col_utf8 , col_iso) from t1 order by 1;

-- cast
select cast(col_binary as string collate utf8_bin) || cast(col_euckr as string collate utf8_bin) || cast(col_utf8 as string collate utf8_bin) || cast(col_iso as string collate utf8_bin) from t1 order by 1;

select cast(col_binary as string collate binary) || cast(col_euckr as string collate binary) || cast(col_utf8 as string collate binary) || cast(col_iso as string collate binary)  from t1 order by 1;

-- late binding
prepare s from 'select col_binary || ?  from t1 order by 1';
execute s using '가';
DEALLOCATE PREPARE s;

prepare s from 'select col_euckr || ?  from t1 order by 1';
execute s using '가';
DEALLOCATE PREPARE s;

-- index 
select * from t1 where substring(col_binary,1,1)=chr(0);

-- column charset conversion
select * from t1 where col_binary=col_euckr order by 1,2,3;
select * from t1 where col_binary=col_utf8 order by 1,2,3;
select * from t1 where col_binary=col_iso order by 1,2,3;
drop table t1;

set names iso88591;
commit;
--+ holdcas off;
