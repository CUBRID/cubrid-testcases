--+ holdcas on;
--tests '05/26/2008' using operators ||, +, -


select date'05/26/2008'||3 from db_root;
select 'It is '||date'05/26/2008'||3 from db_root;
select date'05/26/2008'+3 from db_root;
select date'05/26/2008'-3 from db_root order by 1;

set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';

select date'05/26/2008'||3 from db_root;
select 'It is '||date'05/26/2008'||3 from db_root;
select date'05/26/2008'+3 from db_root;
select date'05/26/2008'-3 from db_root order by 1;

set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
