--normal test, string arguments

--timeltz format
select timediff('11:59:59 pm', '1:1:1');
select timediff('1:1:2', '1:1:1');
select timediff('11:59:58 pm', '11:59:59 pm');

--date format
select timediff('2011-03-17', '03/17/2011'); 
select timediff('2011-03-17', '03/16/2011'); 
select timediff('2011-03-17', '08/16/2010');

--timestampltz format
select timediff('1999-10-10 18:14:45', '1999-10-10 6:14:45');  
select timediff('1999-10-10 18:14:45', '1999-10-10 19:14:45');  
select timediff('1999-10-10 18:14:45', '1989-10-10 6:14:45');  

--datetimeltz format
select timediff('1999-10-10 18:14:45.999', '1999-10-10 6:14:45.888');  
select timediff('1999-10-10 18:14:45.729378', '1999-10-10 19:14:45.000');  
select timediff('1999-10-10 18:14:45.321', '1989-10-10 6:14:45.210');  


