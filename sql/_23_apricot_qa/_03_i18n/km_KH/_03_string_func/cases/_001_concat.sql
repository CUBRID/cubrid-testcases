--+ holdcas on;
set names utf8;
SELECT 'មិនា' + 'មេសា';

SELECT '១០' || 'វិច្ឆិកា';

select concat('ព្រឹក','ល្ងាច');

select concat_ws(' ធ្នូ','វិច្ឆិកា','តុលា');
set names iso88591;
commit;
--+ holdcas off;