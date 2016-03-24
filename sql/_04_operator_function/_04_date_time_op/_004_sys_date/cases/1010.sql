--+ holdcas on;
--tests '14:24:00 05/26/2008' using operators ||, +, -


select timestamp'14:24:00 05/26/2008'||3 from db_root;
select timestamp'14:24:00 05/26/2008'+3 from db_root;
select 'It is '||timestamp'14:24:00 05/26/2008' from db_root;
select timestamp'14:24:00 05/26/2008'-3 from db_root;

set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';

select timestamp'14:24:00 05/26/2008'||3 from db_root;
select timestamp'14:24:00 05/26/2008'+3 from db_root;
select 'It is '||timestamp'14:24:00 05/26/2008' from db_root;
select timestamp'14:24:00 05/26/2008'-3 from db_root;

set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
