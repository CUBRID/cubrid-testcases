--+ holdcas on;
set names utf8;
SELECT 'aöşüz' + 'öşü';

SELECT 'aöşüz' || 'öşü';

select concat('ı','İ');

select concat_ws('ö','Salı','PAZARTESİ');
set names iso88591;
commit;
--+ holdcas off;
