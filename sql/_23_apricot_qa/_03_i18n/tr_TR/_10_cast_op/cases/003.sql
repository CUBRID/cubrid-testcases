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
select timetest from func_03 order by 1;
--test
select cast(timetest as string) from func_03 order by 1;
--test
select cast(timetest as varchar(25)) from func_03 order by 1;
--test
select cast(timetest as char(25)) from func_03 order by 1;
--test
select cast(timetest as date) from func_03 order by 1;
--test
select cast(timetest as time) from func_03 order by 1;
--test
select cast(timetest as timestamp) from func_03 order by 1;
--test
select cast(timetest as nchar(25)) from func_03 order by 1;
--test
select cast(timetest as nchar varying(25)) from func_03 order by 1;
--test
select cast(set{timetest} as set of timestamp) from func_03 order by 1;
--test
select cast(multiset{timetest} as multiset of timestamp) from func_03 order by 1;
--test
select cast(list{timetest} as list of timestamp) from func_03 order by 1;
--test
select cast(timetest as char(8)) from func_03 order by 1;
--test
select cast(timetest as int) from func_03 order by 1;
--test
select cast(timetest as smallint) from func_03 order by 1;
--test
select cast(timetest as numeric(38,10)) from func_03 order by 1;
--test
select cast(timetest as float) from func_03 order by 1;
--test
select cast(timetest as double) from func_03 order by 1;
--test
select cast(timetest as monetary) from func_03 order by 1;
--test
select cast(timetest as bit(80)) from func_03 order by 1;
--test
select cast(timetest as bit varying(80)) from func_03 order by 1;
--test
select cast(timetest as set of string) from func_03 order by 1;
--test
select cast(timetest as multiset of string) from func_03 order by 1;
--test
select cast(timetest as list of string) from func_03 order by 1;
drop table func_03;
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;


