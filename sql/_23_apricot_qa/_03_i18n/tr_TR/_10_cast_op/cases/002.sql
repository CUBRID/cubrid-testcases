--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
create class func_03(
datetimetest    DATETIME,
datetest        date,
timetest        time,
timestamptest           timestamp
);
insert into func_03 values (DATETIME '2011-05-01 PAZAR 10:11:12.678', DATE '2011-05-01 PAZAR', TIME '10:11:12 AM', TIMESTAMP '2011-05-01 PAZAR 10:11:12');
insert into func_03 values (null,null,null);
--test
select timestamptest from func_03 order by 1;
--test
select cast(timestamptest as string) from func_03 order by 1;
--test
select cast(timestamptest as varchar(25)) from func_03 order by 1;
--test
select cast(timestamptest as char(25)) from func_03 order by 1;
--test
select cast(timestamptest as date) from func_03 order by 1;
--test
select cast(timestamptest as time) from func_03 order by 1;
--test
select cast(timestamptest as timestamp) from func_03 order by 1;
--test
select cast(timestamptest as nchar(25)) from func_03 order by 1;
--test
select cast(timestamptest as nchar varying(25)) from func_03 order by 1;
--test
select cast(set{timestamptest} as set of timestamp) from func_03 order by 1;
--test
select cast(multiset{timestamptest} as multiset of timestamp) from func_03 order by 1;
--test
select cast(list{timestamptest} as list of timestamp) from func_03 order by 1;
--test
select cast(timestamptest as char(8)) from func_03 order by 1;
--test
select cast(timestamptest as int) from func_03 order by 1;
--test
select cast(timestamptest as smallint) from func_03 order by 1;
--test
select cast(timestamptest as numeric(38,10)) from func_03 order by 1;
--test
select cast(timestamptest as float) from func_03 order by 1;
--test
select cast(timestamptest as double) from func_03 order by 1;
--test
select cast(timestamptest as monetary) from func_03 order by 1;
--test
select cast(timestamptest as bit(80)) from func_03 order by 1;
--test
select cast(timestamptest as bit varying(80)) from func_03 order by 1;
--test
select cast(timestamptest as set of string) from func_03 order by 1;
--test
select cast(timestamptest as multiset of string) from func_03 order by 1;
--test
select cast(timestamptest as list of string) from func_03 order by 1;

drop table func_03;
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

