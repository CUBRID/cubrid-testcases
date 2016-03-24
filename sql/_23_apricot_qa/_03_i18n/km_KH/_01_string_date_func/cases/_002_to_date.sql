--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = km_KH';
-- date
select 'to_date( , DAY )';
SELECT TO_DATE('2011-05-01 ថ្ងៃអាទិត្យ', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-02 ​ថ្ងៃច័ន្ទ', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-03 ថ្ងៃអង្គារ', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-04 ថ្ងៃពុធ', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-05 ថ្ងៃព្រហស្បតិ៍', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-06 ថ្ងៃសុក្រ', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-07 ថ្ងៃសៅរ៍', 'yyyy-MM-DD DAY');

select 'to_date( ,  day )';
SELECT TO_DATE('2011-05-01 ថ្ងៃអាទិត្យ', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-02 ​ថ្ងៃច័ន្ទ', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-03 ថ្ងៃអង្គារ', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-04 ថ្ងៃពុធ', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-05 ថ្ងៃព្រហស្បតិ៍', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-06 ថ្ងៃសុក្រ', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-07 ថ្ងៃសៅរ៍', 'yyyy-MM-DD day');

select 'to_date( , DY )';
SELECT TO_DATE('2011-05-01 អា', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-02 ច', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-03 អ', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-04 ពុ', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-05 ព្រ', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-06 សុ', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-07 ស', 'yyyy-MM-DD DY');

select 'to_date( ,  dy )';
SELECT TO_DATE('2011-05-01 អា', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-02 ច', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-03 អ', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-04 ពុ', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-05 ព្រ', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-06 សុ', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-07 ស', 'yyyy-MM-DD dy');

-- month
select 'to_date( ,  MONTH)';
SELECT TO_DATE('2010-01 មករា', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 កុម្ភៈ', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 មិនា', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 មេសា', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 ឧសភា', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 មិថុនា', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 កក្កដា', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 សីហា', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 កញ្ញា', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 តុលា', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 វិច្ឆិកា', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 ធ្នូ', 'yyyy-dd MONTH');

select 'to_date( ,  month)';
SELECT TO_DATE('2010-01 មករា', 'yyyy-dd month');
SELECT TO_DATE('2010-01 កុម្ភៈ', 'yyyy-dd month');
SELECT TO_DATE('2010-01 មិនា', 'yyyy-dd month');
SELECT TO_DATE('2010-01 មេសា', 'yyyy-dd month');
SELECT TO_DATE('2010-01 ឧសភា', 'yyyy-dd month');
SELECT TO_DATE('2010-01 មិថុនា', 'yyyy-dd month');
SELECT TO_DATE('2010-01 កក្កដា', 'yyyy-dd month');
SELECT TO_DATE('2010-01 សីហា', 'yyyy-dd month');
SELECT TO_DATE('2010-01 កញ្ញា', 'yyyy-dd month');
SELECT TO_DATE('2010-01 តុលា', 'yyyy-dd month');
SELECT TO_DATE('2010-01 វិច្ឆិកា', 'yyyy-dd month');
SELECT TO_DATE('2010-01 ធ្នូ', 'yyyy-dd month');


select 'to_date( ,  MON)';
SELECT TO_DATE('2010-01 ១', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 ២', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 ៣', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 ៤', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 ៥', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 ៦', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 ៧', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 ៨', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 ៩', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 ១០', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 ១១', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 ១២', 'yyyy-dd MON');

select 'to_date( ,  mon)';
SELECT TO_DATE('2010-01 ១', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ២', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ៣', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ៤', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ៥', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ៦', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ៧', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ៨', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ៩', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ១០', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ១១', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ១២', 'yyyy-dd mon');

select 'to_date( ,  Month)';
SELECT TO_DATE('2010-01 មករា', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 កុម្ភៈ', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 មិនា', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 មេសា', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 ឧសភា', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 មិថុនា', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 កក្កដា', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 សីហា', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 កញ្ញា', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 តុលា', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 វិច្ឆិកា', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 ធ្នូ', 'yyyy-dd Month');

select 'to_date( ,  Mon)';
SELECT TO_DATE('2010-01 ១', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 ២', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 ៣', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 ៤', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 ៥', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 ៦', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 ៧', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 ៨', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 ៩', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 ១០', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 ១១', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 ១២', 'yyyy-dd Mon');

-- text
SELECT TO_DATE('2010-01 te១t ១១', 'yyyy-dd "te១t" Mon');

SELECT TO_DATE('2010-01 te២t ១១', 'yyyy-dd "te២t" Mon');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;


