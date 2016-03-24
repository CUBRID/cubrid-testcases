--+ holdcas on;
set names utf8;
SELECT '我们' + '测试';

SELECT '可以' || '测试';

select concat('我','写');

select concat_ws('我','你们','可以');
set names iso88591;
commit;
--+ holdcas off;
