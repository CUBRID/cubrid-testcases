--normal test

--time 
select timediff(time'11:59:59 pm', time'1:1:1');
select timediff(time'1:1:2', time'1:1:1');
select timediff(time'11:59:58 pm', time'11:59:59 pm');

--date
select timediff(date'2011-03-17', date'03/17/2011'); 
select timediff(date'2011-03-17', date'03/16/2011'); 
select timediff(date'2011-03-17', date'08/16/2010');

--timestamp
select timediff(timestamp'1999-10-10 18:14:45', timestamp'1999-10-10 6:14:45');  
select timediff(timestamp'1999-10-10 18:14:45', timestamp'1999-10-10 19:14:45');  
select timediff(timestamp'1999-10-10 18:14:45', timestamp'1989-10-10 6:14:45');  

--datetime
select timediff(datetime'1999-10-10 18:14:45.999', datetime'1999-10-10 6:14:45.888');  
select timediff(datetime'1999-10-10 18:14:45.729378', datetime'1999-10-10 19:14:45.000');  
select timediff(datetime'1999-10-10 18:14:45.321', datetime'1989-10-10 6:14:45.210');  


