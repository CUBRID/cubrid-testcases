--+ holdcas on;
create class test_class (bigint_col bigint, char_col char(10));
insert into test_class(bigint_col, char_col) values (-9223372036854775808, 'minus');
insert into test_class(bigint_col, char_col) values (9223372036854775807, 'plus');
insert into test_class(bigint_col, char_col) values (-100, 'minus');
insert into test_class(bigint_col, char_col) values (0, 'zero');
insert into test_class(bigint_col, char_col) values (100, 'plus');
insert into test_class(bigint_col, char_col) values (109, 'plus');
insert into test_class(bigint_col, char_col) values (NULL, 'null');

select bigint_col || ' ' || char_col from test_class order by 1;
select char_col || ' ' || bigint_col from test_class order by 1 asc;
select bigint_col || ' , OK' from test_class order by 1 desc;
select 'BIGINT: ' || bigint_col from test_class order by 1;

set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';

select bigint_col || ' ' || char_col from test_class order by 1 desc;
select char_col || ' ' || bigint_col from test_class order by 1;
select bigint_col || ' , OK' from test_class order by 1;
select 'BIGINT: ' || bigint_col from test_class order by 1;

set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';

drop class test_class;
commit;
--+ holdcas off;
