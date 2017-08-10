autocommit off;
create class test_class (col_datetime datetimetz); 
insert into test_class(col_datetime) values('04:10:55 PM 06/03/2009') 

select length('' || extract(millisecond from col_datetime))  from test_class;
select decode(extract(millisecond from col_datetime), 0, 'NOK', 'OK')  from test_class;

set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';

select length('' || extract(millisecond from col_datetime))  from test_class;
select decode(extract(millisecond from col_datetime), 0, 'NOK', 'OK')  from test_class;

set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';

drop class test_class;
commit;
autocommit on;
