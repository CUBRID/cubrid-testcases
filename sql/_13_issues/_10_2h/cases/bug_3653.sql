--[er]
select cast(cast(cast(b'1' as int) as int) as int);
--[er]
select cast(cast(cast(b'1' as bit(1)) as int) as int);
--[er]
select cast(cast(cast(b'1' as bit(1)) as bit(1)) as int);

--[er]
select cast(pow(b'1',1) as int);
--[er]
select cast(cos(b'1') as int);
--[er]
select cast(x'g' as int);
--[er]
select cast(b'2' as int);


--[er]
select cast(cast(cast('abc' as blob) as int) as string);
--[er]
select cast((cast(char_to_clob(123) as set)) as string);
