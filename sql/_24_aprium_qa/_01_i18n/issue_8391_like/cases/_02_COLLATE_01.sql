set names utf8;
select 1 from db_class where 'acb' collate utf8_en_ci like '%B' limit 1;
select 1 from db_class where 'acb' like '%B' collate utf8_en_ci escape '%' limit 1;
select 1 from db_class where 'bacb' collate utf8_gen_ci like '_B%' limit 1;
select 1 from db_class where 'bacb' collate utf8_de_exp_ai_ci like '_B%' escape '_' limit 1;
select 1 from db_class where 'cb' like '%B' collate utf8_en_ci limit 1;

set names utf8 collate utf8_en_ci;
select 1 from db_class where '金b' collate utf8_en_cs like '%B' limit 1;
select 1 from db_class where '金b' collate utf8_en_cs like '%B' escape '%' limit 1;

select 1 from db_class where 'Iİ' collate utf8_tr_cs_uca like '_İ' limit 1;
select 1 from db_class where 'Iİ' like '_İ' collate utf8_tr_cs escape '_' limit 1;
select 1 from db_class where 'ıcb' collate utf8_tr_cs like '_I%' collate utf8_tr_cs limit 1;
select 1 from db_class where 'ıIcb' collate utf8_tr_cs_uca like '_I%' collate utf8_tr_cs_uca escape '_' limit 1;
set names utf8;
select 1 from db_class where 'ü' collate utf8_de_exp_ai_ci like '_Ü' escape '_' limit 1;
select 1 from db_class where 'Äü' like '%Ü' collate utf8_de_exp_ai_ci escape '%' limit 1;

select 1 from db_class where 'ぁぁゝ' collate utf8_ja_exp_cbm like '_ぁ' limit 1;
select 1 from db_class where 'ぁぁゝ' like '%ぁゝ' collate utf8_ja_exp_cbm escape '%' limit 1;
select 1 from db_class where 'ぁゝぁゝ' collate utf8_ja_exp_cbm like '_ぁゝ%' collate utf8_ja_exp_cbm escape '_' limit 1;

select 1 from db_class where _utf8'abc' like _utf8'__C' limit 1;
set names utf8 collate utf8_gen_ai_ci;
select 1 from db_class where _utf8'abc' like _utf8'__C' limit 1;

set names iso88591;
