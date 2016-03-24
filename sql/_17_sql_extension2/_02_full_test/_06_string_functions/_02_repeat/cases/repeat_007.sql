--+ holdcas on;
--exceptional cases

set system parameters 'string_max_size_bytes=1048576'; 
--null value
select repeat(null, 5);
select repeat('hello', null);
select repeat(null, null);


--pass nothing
select repeat( , 5);
select repeat('hello', );


--pass empty string to str
select repeat('', 10);
--pass space to str
select repeat('   ', 5);


--pass 0 to count
select repeat('hello', 0);
--pass negative value to count
select repeat('hello', -100);


--pass unmatched format to a date/time type argument
select repeat(date'abcd', 7);
select repeat(timestamp'1900000', 30);


--wrong number of params
select repeat();
select repeat(null);
select repeat('abcd');
select repeat(3);
select repeat('abc', 6, 7);

select char_length(repeat('x', 123231));
select char_length(repeat('x', 1232311233)); 
select char_length(repeat('xxxxxxxxxxxxx', 123231));


set system parameters 'string_max_size_bytes=1048576';
commit;
--+ holdcas off;
