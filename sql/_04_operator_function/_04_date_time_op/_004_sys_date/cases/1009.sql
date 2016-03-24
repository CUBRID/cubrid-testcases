--+ holdcas on;
--tests '14:24:00' using operators ||, +, -


select time'14:24:00'||3 from db_root;
select time'14:24:00'+3 from db_root;
select 'It is '||time'14:24:00' from db_root;
select time'14:24:00'-3 from db_root;

set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';

select time'14:24:00'||'3' from db_root;
select time'14:24:00'+3 from db_root;
select 'It is '||time'14:24:00' from db_root;
select time'14:24:00'-3 from db_root;

set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
