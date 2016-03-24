--+ holdcas on;
set names utf8;
SELECT '午前' + '午後';

SELECT '西暦' || '午後';

select concat('紀','元');

select concat_ws('2011年','12月19日','月曜日');
set names iso88591;
commit;
--+ holdcas off;