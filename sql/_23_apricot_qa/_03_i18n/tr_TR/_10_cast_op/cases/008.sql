--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
create class func_03(
varchartest     varchar(40),
chartest        char(40),
stringtest      string);
insert into func_03 values ('2011-05-01 PAZAR 10:11:12', '2011-05-01 PAZAR 10:11:12', '2011-05-01 PAZAR 10:11:12');
insert into func_03 values (null,null,null);
--test
select cast(varchartest as timestamp) from func_03 order by 1;
--test
select cast(chartest as timestamp) from func_03 order by 1;
--test
select cast(stringtest as timestamp) from func_03 order by 1;
drop table func_03;
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

