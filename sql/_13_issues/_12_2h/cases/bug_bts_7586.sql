
--AM datetime tests, no errors
select STR_TO_DATE('May 1, 2012 11:30:34', '%M %d, %Y %h:%i:%s');
select STR_TO_DATE('May 1, 2012 11:30:34', '%M %d, %Y %H:%i:%s');
select STR_TO_DATE('May 1, 2012 11:30:34 AM', '%M %d, %Y %h:%i:%s %p');

--PM datetime tests, no errors
select STR_TO_DATE('May 1, 2012 11:30:34', '%M %d, %Y %h:%i:%s');
select STR_TO_DATE('May 1, 2012 23:30:34', '%M %d, %Y %H:%i:%s');
select STR_TO_DATE('May 1, 2012 11:30:34 PM', '%M %d, %Y %h:%i:%s %p');

--datetime tests, with errors
select STR_TO_DATE('May 1, 2012 23:30:34', '%M %d, %Y %h:%i:%s');
select STR_TO_DATE('May 1, 2012 11:30:34 PM', '%M %d, %Y %H:%i:%s %p');

--time tests
select STR_TO_DATE('11:30:34 AM', '%h:%i:%s %p');
select STR_TO_DATE('11:30:34 PM', '%H:%i:%s %p');
select STR_TO_DATE('11:30:34', '%h:%i:%s');
select STR_TO_DATE('11:30:34', '%H:%i:%s');

select STR_TO_DATE('23:30:34 AM', '%h:%i:%s %p');
select STR_TO_DATE('23:30:34 PM', '%H:%i:%s %p');
select STR_TO_DATE('23:30:34', '%h:%i:%s');
select STR_TO_DATE('23:30:34', '%H:%i:%s');

select STR_TO_DATE('23:30:34', '%T');
select STR_TO_DATE('11:30:34 AM', '%r');
select STR_TO_DATE('11:30:34 PM', '%r');
