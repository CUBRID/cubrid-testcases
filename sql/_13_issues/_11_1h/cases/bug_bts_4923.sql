autocommit off;

set system parameters 'string_max_size_bytes=10';

set system parameters 'group_concat_max_len=-1';

set system parameters 'string_max_size_bytes=1048576';

set system parameters 'group_concat_max_len=1024';

rollback;

autocommit on;

