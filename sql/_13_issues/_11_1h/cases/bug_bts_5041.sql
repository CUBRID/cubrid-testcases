--+ holdcas on;

set system parameters 'return_null_on_function_errors = no';

select timediff ('1:1:2','1:1:1');

select if(timediff('1:1:2','1:1:1') = timediff(time'1:1:2',time'1:1:1'), 'ok','nok');

select timediff ('2011-01-01', '2010-01-01');

select timediff ('12:34:76','12:34:76');

CREATE table timediff_test(
char_col char(255),
varchar_col varchar(255),
nchar_col nchar(255),
varnchar_col nchar varying(255)
);

insert into timediff_test values( '1:1:2', '1:1:1' ,N'2011-01-01', N'2010-01-01');


select timediff (varnchar_col,nchar_col) from timediff_test;

select timediff (varnchar_col, varnchar_col) from timediff_test;

select timediff (varchar_col, varchar_col) from timediff_test;

select timediff (varchar_col,char_col) from timediff_test;

select timediff (nchar_col,nchar_col) from timediff_test;

select timediff (nchar_col, varnchar_col) from timediff_test;

select timediff (char_col, varchar_col) from timediff_test;

select timediff (char_col,char_col) from timediff_test;

drop table timediff_test;

set system parameters 'return_null_on_function_errors = yes';set system parameters 'return_null_on_function_errors = no';

select timediff ('1:1:2','1:1:1');

select if(timediff('1:1:2','1:1:1') = timediff(time'1:1:2',time'1:1:1'), 'ok','nok');

select timediff ('2011-01-01', '2010-01-01');

select timediff ('12:34:76','12:34:76');


CREATE table timediff_test(
char_col char(255),
varchar_col varchar(255),
nchar_col nchar(255),
varnchar_col nchar varying(255)
);

insert into timediff_test values( '1:1:2', '1:1:1' ,N'2011-01-01', N'2010-01-01');


select timediff (varnchar_col,nchar_col) from timediff_test;

select timediff (varnchar_col, varnchar_col) from timediff_test;

select timediff (varchar_col, varchar_col) from timediff_test;

select timediff (varchar_col,char_col) from timediff_test;

select timediff (nchar_col,nchar_col) from timediff_test;

select timediff (nchar_col, varnchar_col) from timediff_test;

select timediff (char_col, varchar_col) from timediff_test;

select timediff (char_col,char_col) from timediff_test;

drop table timediff_test;

commit;

--+ holdcas off;

