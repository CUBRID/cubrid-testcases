--exceptional cases


--unexisted delim
select substring_index('a-b-c', '/', 2);
select substring_index(123123123, 4, 3);
select substring_index(date'10/10/2010', '-', -2);


--unmatched format of date/time values
select substring_index(date'aaa', '-', -2);
select substring_index(time'bbb', '-', -2);
select substring_index(datetime'10/10/2010', '-', -2);
select substring_index(timestamp'123', '-', -2);


--pass null
select substring_index(null, '/', 2);
select substring_index('a-b-c', null, 2);
select substring_index('a-b-c', '-', null);


--pass nothing
select substring_index(, '/', 2);
select substring_index('a-b-c', , 2);
select substring_index('a-b-c', '/', );


--pass empty string
select substring_index('', '', 1);
select substring_index('a-b-c', '', 2);


--pass space
select char_length(substring_index('     ', ' ', 2));
--space as a deliminater
select substring_index('aaa bbb ccc ddd', ' ', 2);


--pass unmatched number of params
select substring_index();
select substring_index(null);
select substring_index('a-b-c');
select substring_index('a-b-c', '-');
select substring_index('a-b-c', '/', 2, 1);


