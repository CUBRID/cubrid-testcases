--exceptional cases


--empty string
select version('');

--2 params
select version(1, 2);

--null
select version(null);

--wrong format
select version;


