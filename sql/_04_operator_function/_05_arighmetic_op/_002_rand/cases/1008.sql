--+ holdcas on;
--test random with char type and operator ||

select decode(random()||'abc' , null , 0,1) from db_root;
set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';
select decode(random()||'abc' , null , 0,1) from db_root;
set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';

commit;
--+ holdcas off;
