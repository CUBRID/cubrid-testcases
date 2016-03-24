set names iso88591 collate iso88591_en_ci;
select 1 from db_class where 'acb' like '%B' limit 1; 
select 1 from db_class where 'acb' like '%B' escape '%' limit 1;
select 1 from db_class where 'Bacb' like '_B%' limit 1;
select 1 from db_class where 'Bacb' like '_B%' escape '_' limit 1;

set names utf8 collate utf8_en_ci;
select 1 from db_class where '金b' like '%B' limit 1;
select 1 from db_class where '金b' like '%B' escape '%' limit 1;
select 1 from db_class where '金b' like '_B' limit 1;
select 1 from db_class where '金b' like '_B' escape '_' limit 1;

set names utf8 collate utf8_gen_ci;
select 1 from db_class where 'ab' like '%B' limit 1;
select 1 from db_class where 'ab' like '%B' escape '%' limit 1;
set names utf8 collate utf8_gen_ai_ci;
select 1 from db_class where 'B金cb' like '_B%' limit 1;
select 1 from db_class where 'B金色cb' like '_B%' escape '_' limit 1;

set names utf8 collate utf8_tr_cs;
select 1 from db_class where 'Iİ' like '_İ' limit 1;
select 1 from db_class where 'Iİ' like '_İ' escape '_' limit 1;
set names utf8 collate utf8_tr_cs_uca;
select 1 from db_class where 'ıcb' like '_I%' limit 1;
select 1 from db_class where 'ıcb' like '_I%' escape '_' limit 1;

set names utf8 collate utf8_de_exp_ai_ci;
select 1 from db_class where 'ü' like '_Ü' escape '_' limit 1;
select 1 from db_class where 'Äü' like '%Ü' escape '%' limit 1;

set names utf8 collate utf8_ja_exp_cbm;
select 1 from db_class where 'ぁぁゝ' like '_ぁ' limit 1;
select 1 from db_class where 'ぁぁゝ' like '%ぁゝ' escape '%' limit 1;
select 1 from db_class where 'ぁゝぁゝ' like '_ぁゝ%' escape '_' limit 1;

set names iso88591;
