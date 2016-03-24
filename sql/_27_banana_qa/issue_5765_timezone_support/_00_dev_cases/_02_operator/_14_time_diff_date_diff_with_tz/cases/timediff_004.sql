autocommit off;
--exceptional cases: pass different types of data to 2 params

--timetz&other 
select timediff(time'11:59:59 pm', date'2011-03-17');
select timediff(time'1:1:2', timestamptz'2011-03-07 1:1:1');
select timediff(time'11:59:58 pm', datetimetz'03/09/1998 11:59:58 pm');

--date&other
select timediff(date'2011-03-17', time'13:12:45'); 
select timediff(date'2011-03-17', timestamptz'03/16/2011 4:5:56'); 
select timediff(date'2011-03-17', datetimetz'08/16/2010 12:12:12.1234');

--timestamptz&other
select timediff(timestamptz'1999-10-10 18:14:45', date'1999-10-10');  
select timediff(timestamptz'1999-10-10 18:14:45', time'19:14:45');  
select timediff(timestamptz'1999-10-10 18:14:45', datetimetz'1989-10-10 6:14:45.456');  

--datetimetz&other
select timediff(datetimetz'1999-10-10 18:14:45.999', date'1999-10-10');  
select timediff(datetimetz'1999-10-10 18:14:45.729378', time'19:14:45');  
select timediff(datetimetz'1999-10-10 18:14:45.321', timestamptz'1989-10-10 6:14:45');  


set system parameters 'return_null_on_function_errors=yes';

--timetz&other 
select timediff(time'11:59:59 pm', date'2011-03-17');
select timediff(time'1:1:2', timestamptz'2011-03-07 1:1:1');
select timediff(time'11:59:58 pm', datetimetz'03/09/1998 11:59:58 pm');

--date&other
select timediff(date'2011-03-17', time'13:12:45');
select timediff(date'2011-03-17', timestamptz'03/16/2011 4:5:56');
select timediff(date'2011-03-17', datetimetz'08/16/2010 12:12:12.1234');

--timestamptz&other
select timediff(timestamptz'1999-10-10 18:14:45', date'1999-10-10');
select timediff(timestamptz'1999-10-10 18:14:45', time'19:14:45');
select timediff(timestamptz'1999-10-10 18:14:45', datetimetz'1989-10-10 6:14:45.456');

--datetimetz&other
select timediff(datetimetz'1999-10-10 18:14:45.999', date'1999-10-10');
select timediff(datetimetz'1999-10-10 18:14:45.729378', time'19:14:45');
select timediff(datetimetz'1999-10-10 18:14:45.321', timestamptz'1989-10-10 6:14:45');

set system parameters 'return_null_on_function_errors=no';

commit;
autocommit on;
