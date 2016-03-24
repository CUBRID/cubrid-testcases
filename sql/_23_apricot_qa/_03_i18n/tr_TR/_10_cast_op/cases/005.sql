--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
create class func_03(
datetimetest    DATETIME,
datetest        date,
timetest        time,
timestamptest          timestamp
);
insert into func_03 values (DATETIME '2011-05-01 PAZAR 10:11:12.678', DATE '2011-05-01 PAZAR', TIME '10:11:12 AM', TIMESTAMP '2011-05-01 PAZAR 10:11:12');
insert into func_03 values (null,null,null);
--test
select datetimetest from func_03 order by 1;
--test
select cast(datetimetest as string) from func_03 order by 1;
--test
select cast(datetimetest as varchar(25)) from func_03 order by 1;
--test
select cast(datetimetest as char(25)) from func_03 order by 1;
--test
select cast(datetimetest as date) from func_03 order by 1;
--test
select cast(datetimetest as time) from func_03 order by 1;
--test
select cast(datetimetest as timestamp) from func_03 order by 1;
--test
select cast(datetimetest as nchar(25)) from func_03 order by 1;
--test
select cast(datetimetest as nchar varying(25)) from func_03 order by 1;
--test
select cast(set{datetimetest} as set of timestamp) from func_03 order by 1;
--test
select cast(multiset{datetimetest} as multiset of timestamp) from func_03 order by 1;
--test
select cast(list{datetimetest} as list of timestamp) from func_03 order by 1;
--test
select cast(datetimetest as char(8)) from func_03 order by 1;
--test
select cast(datetimetest as int) from func_03 order by 1;
--test
select cast(datetimetest as smallint) from func_03 order by 1;
--test
select cast(datetimetest as numeric(38,10)) from func_03 order by 1;
--test
select cast(datetimetest as float) from func_03 order by 1;
--test
select cast(datetimetest as double) from func_03 order by 1;
--test
select cast(datetimetest as monetary) from func_03 order by 1;
--test
select cast(datetimetest as bit(80)) from func_03 order by 1;
--test
select cast(datetimetest as bit varying(80)) from func_03 order by 1;
--test
select cast(datetimetest as set of string) from func_03 order by 1;
--test
select cast(datetimetest as multiset of string) from func_03 order by 1;
--test
select cast(datetimetest as list of string) from func_03 order by 1;
drop table func_03;
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;


