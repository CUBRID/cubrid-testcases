select if(typeof(cast(1 as short)) = 'smallint', 'ok', 'nok');
select if(typeof(cast(1 as int)) = 'integer', 'ok', 'nok');
select if(typeof(cast(1 as bigint)) = 'bigint', 'ok', 'nok');
select if(typeof(cast(1 as float)) = 'float', 'ok', 'nok');
select if(typeof(cast(1 as double)) = 'double', 'ok', 'nok');
select if(typeof(cast(1 as monetary)) = 'monetary', 'ok', 'nok');

--- blob/clob
select if(typeof(char_to_blob('a')) = 'blob', 'ok', 'nok');
select if(typeof(char_to_clob('a')) = 'clob', 'ok', 'nok');

-- sequence
select if(typeof({1}) = 'sequence', 'ok', 'nok');


select if(typeof('a') = 'character (-1)', 'ok', 'nok');
select if(typeof(cast('a' as char(8))) = 'character (8)', 'ok', 'nok');
select if(typeof(cast('a' as varchar(8))) = 'character varying (8)', 'ok', 'nok');

select if(typeof(n'a') = 'national character (-1)', 'ok', 'nok');
select if(typeof(cast(n'a' as nchar(8))) = 'national character (8)', 'ok', 'nok');
select if(typeof(cast(n'a' as nchar varying(8))) = 'national character varying (8)', 'ok', 'nok');

select if(typeof(b'111') = 'bit (-1)', 'ok', 'nok');
select if(typeof(cast(b'111' as bit(8))) = 'bit (8)', 'ok', 'nok');
select if(typeof(cast(b'111' as bit varying(8))) = 'bit varying (8)', 'ok', 'nok');

select if(typeof(1.1) = 'numeric (2, 1)', 'ok', 'nok');
select if(typeof(cast(1.1 as numeric(15,5))) = 'numeric (15, 5)', 'ok', 'nok');

