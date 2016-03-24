--+ holdcas on;
--tests last_day with operators +, -


select last_day(date'2/1/2008')+3 from db_root;
select last_day(date'2/1/2008')-3 from db_root order by 1;

set system parameters 'compat_mode=mysql';

select last_day(date'2/1/2008')+3 from db_root;
select last_day(date'2/1/2008')-3 from db_root order by 1;

set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
