--+ holdcas on;

-- should be error
set system parameters 'intl_number_lang = tr_t';



create table t1 (d1 numeric(10,5), si string collate iso88591_en_ci, su string collate utf8_en_ci);
insert into t1 values (123.33,'999.99',_utf8'999.99');

create table t2 (d1 date, si string collate iso88591_en_ci, su string collate utf8_en_ci);
insert into t2 values (date'10/11/2011','DAY MONTH YYYY',_utf8'DAY MONTH YYYY');

-- number
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = en_US';
select to_char(d1, '999,999') from t1;

select to_char(123.123, '999,999');
select to_char(123.123, '999.999');
select to_char(123.123, '999,999','en_US');
select to_char(123.123, '999.999','en_US');
select to_char(123.123, _utf8'999,999');



-- date
set system parameters 'intl_number_lang = en_US';
set system parameters 'intl_date_lang = tr_TR';
select to_char(d1, 'DAY MONTH YYYY') from t2;
select to_char(d1, _utf8'DAY MONTH YYYY') from t2;
select to_char(d1, si) from t2;
select to_char(d1, su) from t2;

select to_char(date'10/11/2011', 'DAY MONTH YYYY');
select to_char(date'10/11/2011', _utf8'DAY MONTH YYYY');
select to_char(date'10/11/2011', 'DAY MONTH YYYY','en_US');
select to_char(date'10/11/2011', 'DAY MONTH YYYY','ko_KR');
select to_char(date'10/11/2011', _utf8'DAY MONTH YYYY','ko_KR');


drop table t1;
drop table t2;


set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
