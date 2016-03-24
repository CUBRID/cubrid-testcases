--+ holdcas on;
set names binary;
SELECT '字符串1' + '字符串2';
SELECT '字符串1' || '字符串1';
select concat('字符串1','字符串1');
select concat_ws('分隔符','字符串1','字符串2');

-- there are different charset
SELECT '字符串1' + _utf8'字符串2';
SELECT '字符串1' || _utf8'字符串2';
select concat('字符串1', _utf8'字符串2');
select concat_ws('分隔符', _utf8'字符串1','字符串2');

SELECT cast( _utf8'문자열 2' as string charset euckr);
SELECT coercibility('字符串1');
SELECT coercibility(cast( _utf8'문자열 2' as string charset euckr));
SELECT '字符串1' collate binary + cast( _utf8'문자열 2' as string charset euckr);
SELECT '字符串1' collate binary + cast( _utf8'문자열 2' as string charset euckr);
SELECT '字符串1' collate binary || cast( _utf8'문자열 2' as string charset euckr);
select concat('字符串1' collate binary, cast( _utf8'문자열 2' as string charset euckr));
select concat_ws('分隔符' collate binary, '字符串1' collate binary,cast( _utf8'문자열 2' as string charset euckr));

set names iso88591;
commit;
--+ holdcas off;
