--+ holdcas on;
--exceptional cases: pass different types of data to 2 params

--time&other 
select timediff(time'11:59:59 pm', date'2011-03-17');
select timediff(time'1:1:2', timestamp'2011-03-07 1:1:1');
select timediff(time'11:59:58 pm', datetime'03/09/1998 11:59:58 pm');

--date&other
select timediff(date'2011-03-17', time'13:12:45'); 
select timediff(date'2011-03-17', timestamp'03/16/2011 4:5:56'); 
select timediff(date'2011-03-17', datetime'08/16/2010 12:12:12.1234');

--timestamp&other
select timediff(timestamp'1999-10-10 18:14:45', date'1999-10-10');  
select timediff(timestamp'1999-10-10 18:14:45', time'19:14:45');  
select timediff(timestamp'1999-10-10 18:14:45', datetime'1989-10-10 6:14:45.456');  

--datetime&other
select timediff(datetime'1999-10-10 18:14:45.999', date'1999-10-10');  
select timediff(datetime'1999-10-10 18:14:45.729378', time'19:14:45');  
select timediff(datetime'1999-10-10 18:14:45.321', timestamp'1989-10-10 6:14:45');  


set system parameters 'return_null_on_function_errors=yes';

--time&other 
select timediff(time'11:59:59 pm', date'2011-03-17');
select timediff(time'1:1:2', timestamp'2011-03-07 1:1:1');
select timediff(time'11:59:58 pm', datetime'03/09/1998 11:59:58 pm');

--date&other
select timediff(date'2011-03-17', time'13:12:45');
select timediff(date'2011-03-17', timestamp'03/16/2011 4:5:56');
select timediff(date'2011-03-17', datetime'08/16/2010 12:12:12.1234');

--timestamp&other
select timediff(timestamp'1999-10-10 18:14:45', date'1999-10-10');
select timediff(timestamp'1999-10-10 18:14:45', time'19:14:45');
select timediff(timestamp'1999-10-10 18:14:45', datetime'1989-10-10 6:14:45.456');

--datetime&other
select timediff(datetime'1999-10-10 18:14:45.999', date'1999-10-10');
select timediff(datetime'1999-10-10 18:14:45.729378', time'19:14:45');
select timediff(datetime'1999-10-10 18:14:45.321', timestamp'1989-10-10 6:14:45');

set system parameters 'return_null_on_function_errors=no';

commit;
--+ holdcas off;
