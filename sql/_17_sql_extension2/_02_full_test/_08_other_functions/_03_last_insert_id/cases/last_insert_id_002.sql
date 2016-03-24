--exceptional cases


--empty string
select last_insert_id('');

--2 params
select last_insert_id(1, 2);

--null
select last_insert_id(null);

--wrong format
select last_insert_id;


