--cast number to date/time type (not support)


--[er]
select cast(20100101 as date);
--[er]
select cast(210145 as time);
--[er]
select cast(201033.23 as time);
--[er]
select cast(20101110105956 as timestamp);
--[er]
select cast(20101110105956.123 as datetime);



--[ok]
select cast(cast(20100101 as string) as date);
--[ok]
select cast(cast(210145 as string) as time);
--[ok]
select cast(cast(201033.23 as string) as time);


--[ok]
select cast(cast(20101110105956 as string) as timestamp);
--[ok]
select cast(cast(20101110105956.123 as string) as datetime);
select cast(cast(2010114343410105956.123 as string) as datetime);
