--TEST: [I18N] Charset name in the result of SHOW COLLATION is not consistent to what we want to use in SET NAMES.

--+ holdcas on;
show collation;

set names utf8;
select length('中');

set names iso88591;
select length('中');

set names euckr;
select length('中');

select * from db_collation;


set names iso88591;
commit;
--+ holdcas off;
