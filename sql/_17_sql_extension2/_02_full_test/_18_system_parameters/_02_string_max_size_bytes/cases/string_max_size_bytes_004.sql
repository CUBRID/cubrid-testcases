--+ holdcas on;
--exceptional cases

--[er]
set system parameters 'string_max_size_bytes=0';
set system parameters 'string_max_size_bytes=-1';
set system parameters 'string_max_size_bytes=1';
set system parameters 'string_max_size_bytes=63';
set system parameters 'string_max_size_bytes=a';

set system parameters 'string_max_size_bytes=64';
select space(65);

set system parameters 'string_max_size_bytes=1048576';
commit;
--+ holdcas off;
