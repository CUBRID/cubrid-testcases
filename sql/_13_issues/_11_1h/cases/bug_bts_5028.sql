--+ holdcas on;

set system parameters 'return_null_on_function_errors = no';

select timediff ('a','b');

select timediff ('12:34:76', '12:00:00');

select timediff ('12:00:00', '12:34:76');

select timediff ('12:34:76','12:34:76');


CREATE table timediff_test(
char_col char(255),
varchar_col varchar(255),
nchar_col nchar(255),
varnchar_col nchar varying(255)
);

insert into timediff_test values( '12:34:76', 'cubrid' ,N'12:67:34', N'cubrid');


select timediff (varnchar_col,nchar_col) from timediff_test;

select timediff (varnchar_col, varnchar_col) from timediff_test;

select timediff (varchar_col, varchar_col) from timediff_test;

select timediff (varchar_col,char_col) from timediff_test;

select timediff (nchar_col,nchar_col) from timediff_test;

select timediff (nchar_col, varnchar_col) from timediff_test;

select timediff (char_col, varchar_col) from timediff_test;

select timediff (char_col,char_col) from timediff_test;

drop table timediff_test;



set system parameters 'return_null_on_function_errors = yes';

select timediff ('a','b');

select timediff ('12:34:76', '12:00:00');

select timediff ('12:00:00', '12:34:76');

select timediff ('12:34:76','12:34:76');


CREATE table timediff_test(
char_col char(255),
varchar_col varchar(255),
nchar_col nchar(255),
varnchar_col nchar varying(255)
);

insert into timediff_test values( '12:34:76', 'cubrid' ,N'12:67:34', N'cubrid');


select timediff (varnchar_col,nchar_col) from timediff_test;

select timediff (varnchar_col, varnchar_col) from timediff_test;

select timediff (varchar_col, varchar_col) from timediff_test;

select timediff (varchar_col,char_col) from timediff_test;

select timediff (nchar_col,nchar_col) from timediff_test;

select timediff (nchar_col, varnchar_col) from timediff_test;

select timediff (char_col, varchar_col) from timediff_test;

select timediff (char_col,char_col) from timediff_test;

drop table timediff_test;


set system parameters 'return_null_on_function_errors = no';

commit;

--+ holdcas off;

