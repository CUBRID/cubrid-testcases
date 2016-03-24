--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
create table t1 (i int unique, b1 blob, c1 clob);
--test
insert into t1 values (1,bit_to_blob(X'C4E3BAC3'),char_to_clob('tr_Çç_Ğğ_İı_Öö_Şş_Üü你好'));
--test
insert into t1 values (2,bit_to_blob(X'E4B8A5'),char_to_clob('test你好Çç_Ğğ_İı_Öö_Şş_Üü'));
--test
select i, blob_to_bit(b1), clob_to_char(c1) from t1 order by 1;
drop table t1;
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
