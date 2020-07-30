--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
drop table if exists t;
create class t(
col1     varchar(40),
col2        char(40),
col3      string,
col4       varchar(40) 
);
insert into t value('2011-05-01 PAZAR 10:11:12.678','2011-05-01 PAZAR 10:11:12','10:11:12 pm','2011-05-01 PAZAR');
insert into t value('2011-5-1 22:23:24.678','2011-05-01 10:11:12','10:11:12 pm','2011-05-01');
--test
ALTER table t change col1 Çç_Ğğ DATETIME;
--test
ALTER table t change col2 İı_Öö Timestamp;
--test
ALTER table t change col3 Şş_Üü Time;
--test
ALTER table t modify col4  DATE;

--test
select * from t order by 1; 

drop table t;
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
