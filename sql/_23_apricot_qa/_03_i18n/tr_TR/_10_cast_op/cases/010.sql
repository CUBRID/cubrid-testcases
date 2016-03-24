--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
create class func_03(
varchartest     varchar(20),
chartest        char(30),
datetest        date,
timetest        time,
timestamptest           timestamp,
datetimetest    DATETIME,
stringtest      string);

insert into func_03 values ( '你好', 'tr_Çç_Ğğ_İı_Öö_Şş_Üü', date'2011-05-01 PAZAR', time'10:11:12 AM', timestamp '2011-05-05 PERŞEMBE 10:11:12',datetime'2011-05-04 ÇARŞAMBA 10:11:12.678', 'test你好Çç_Ğğ_İı_Öö_Şş_Üü');
insert into func_03 values ( '' ,'', null, null, null,null,'');

--test
select cast(varchartest as bit varying(1000)) from func_03 order by 1;
--test
select cast(chartest as bit varying(1000)) from func_03 order by 1;
--test
select cast(datetest as bit varying(1000)) from func_03 order by 1;
--test
select cast(timetest as bit varying(1000)) from func_03 order by 1;
--test
select cast(timestamptest as bit varying(1000)) from func_03 order by 1;
--test
select cast(datetimetest as bit varying(1000)) from func_03 order by 1;
--test
select cast(stringtest as bit varying(1000)) from func_03 order by 1;

drop table func_03;
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

