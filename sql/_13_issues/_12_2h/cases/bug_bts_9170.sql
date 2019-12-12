--TEST: A cub_server core was thrown when run "execute reject" (in intl_identifier_casecmp at ../../src/base/intl_support.c:2771)


drop table if exists x;

create table x(a int);
prepare x from 'insert into x values(ifnull(?,1))';
execute reject;
deallocate prepare x;


prepare x from 'delete from x where a=?';
execute reject;
deallocate prepare x;


prepare x from 'insert into x values(ifnull(?,1))';
execute print;
deallocate prepare x;


prepare x from 'insert into x values(ifnull(?,1))';
execute insert;
deallocate prepare x;


prepare x from 'insert into x values(3)';
execute reject;
deallocate prepare x;


prepare x from 'insert into x values(select ?)';
execute reject;
deallocate prepare x;


drop table x;
