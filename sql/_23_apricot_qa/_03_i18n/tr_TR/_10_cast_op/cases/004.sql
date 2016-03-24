--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
datetimetest    DATETIME,
datetest        date,
timetest        time,
timestamptest          timestamp
);
insert into func_03 values (DATETIME '2011-05-01 PAZAR 10:11:12.678', DATE '2011-05-01 PAZAR', TIME '10:11:12 AM', TIMESTAMP '2011-05-01 PAZAR 10:11:12');
insert into func_03 values (null,null,null);
--test
select datetest from func_03 order by 1;
--test
select cast(datetest as string) from func_03 order by 1;
--test
select cast(datetest as varchar(25)) from func_03 order by 1;
--test
select cast(datetest as char(25)) from func_03 order by 1;
--test
select cast(datetest as date) from func_03 order by 1;
--test
select cast(datetest as time) from func_03 order by 1;
--test
select cast(datetest as timestamp) from func_03 order by 1;
--test
select cast(datetest as nchar(25)) from func_03 order by 1;
--test
select cast(datetest as nchar varying(25)) from func_03 order by 1;
--test
select cast(set{datetest} as set of timestamp) from func_03 order by 1;
--test
select cast(multiset{datetest} as multiset of timestamp) from func_03 order by 1;
--test
select cast(list{datetest} as list of timestamp) from func_03 order by 1;
--test
select cast(datetest as char(8)) from func_03 order by 1;
--test
select cast(datetest as int) from func_03 order by 1;
--test
select cast(datetest as smallint) from func_03 order by 1;
--test
select cast(datetest as numeric(38,10)) from func_03 order by 1;
--test
select cast(datetest as float) from func_03 order by 1;
--test
select cast(datetest as double) from func_03 order by 1;
--test
select cast(datetest as monetary) from func_03 order by 1;
--test
select cast(datetest as bit(80)) from func_03 order by 1;
--test
select cast(datetest as bit varying(80)) from func_03 order by 1;
--test
select cast(datetest as set of string) from func_03 order by 1;
--test
select cast(datetest as multiset of string) from func_03 order by 1;
--test
select cast(datetest as list of string) from func_03 order by 1;
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;


