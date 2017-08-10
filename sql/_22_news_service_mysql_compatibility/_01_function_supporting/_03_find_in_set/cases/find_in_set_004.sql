--TEST: pass numeric values to the 1st param on server side 



create table f04(
	col1 smallint,
	col2 int,
	col3 bigint,
	col4 float,
	col5 double,
	col6 numeric(10, 5),
	col7 monetary
);

insert into f04 values(100, -9890, 123456789987654321, 123.456, -328922342.8923981289, 11111.11111, 45.67);


--TEST: short
select if(find_in_set(col1, '100,-9890,123456789987654321,123.456,-328922342.8923981289,11111.11111,45.67') = 1, 'ok', 'nok') from f04;
--TEST: int
select if(find_in_set(col2, '100,-9890,123456789987654321,123.456,-328922342.8923981289,11111.11111,45.67') = 2, 'ok', 'nok') from f04;
--TEST: bigint
select if(find_in_set(col3, '100,-9890,123456789987654321,123.456,-328922342.8923981289,11111.11111,45.67') = 3, 'ok', 'nok') from f04;
--TEST: float
select if(find_in_set(col4, '100,-9890,123456789987654321,123.456,-328922342.8923981289,11111.11111,45.67') = 4, 'ok', 'nok') from f04;
--TEST: double
select if(find_in_set(col5, '100,-9890,123456789987654321,123.456,-328922342.8923981289,11111.11111,45.67') = 0, 'ok', 'nok') from f04;
--TEST: numeric
select if(find_in_set(col6, '100,-9890,123456789987654321,123.456,-328922342.8923981289,11111.11111,45.67') = 6, 'ok', 'nok') from f04;
--TEST: monetary
select if(find_in_set(col7, '100,-9890,123456789987654321,123.456,-328922342.8923981289,11111.11111,$45.67') = 7, 'ok', 'nok') from f04;


drop table f04;





