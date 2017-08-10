--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = ko_KR';
set system parameters 'intl_date_lang = ko_KR';
create table t( a timestamp);
insert into t value('00:00:00');
insert into t value('70-10-31');
insert into t value('10/31/2008 01:15:45 PM');
insert into t value('10/31/2008 13:15:45');

select * from t order by 1;

drop table t;
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;