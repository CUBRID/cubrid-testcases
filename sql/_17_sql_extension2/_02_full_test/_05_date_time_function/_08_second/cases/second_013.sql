--pass date type data to the param

--returns 9 in mysql
select second(date'2009-4-5');

--returns null in mysql
select second(date'1998-12-23');
