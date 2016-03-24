--exceptional cases


--empty string
select row_count('');

--2 params
select row_count(1, 2);

--null
select row_count(null);

--wrong format
select row_count;


