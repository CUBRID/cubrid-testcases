-- cast char to numeric when empty string is included in char

-- return same result 1.1000000000
select cast(cast(1.1 as char(10)) as numeric(38,10)); 
select cast(cast(1.1 as char varying(10)) as numeric(38,10)); 
select cast(cast(1.1 as nchar(10)) as numeric(38,10)); 
select cast(cast(1.1 as nchar varying(10)) as numeric(38,10)); 
select cast(cast('   1.1   ' as char(10)) as numeric(38,10));
select cast(cast('   1.1' as char(10)) as numeric(38,10));
select cast(cast('1.1   ' as char(10)) as numeric(38,10));
select cast(cast('   1.1   ' as char varying(10)) as numeric(38,10));
select cast(cast('   1.1' as char varying(10)) as numeric(38,10));
select cast(cast('1.1   ' as char varying(10)) as numeric(38,10));
select cast('   1.1   ' as numeric(38,10));
select cast('   1.1' as numeric(38,10));
select cast('1.1   ' as numeric(38,10));

-- return same result -1.1000000000
select cast(cast(-1.1 as char(10)) as numeric(38,10)); 
select cast(cast(-1.1 as char varying(10)) as numeric(38,10)); 
select cast(cast(-1.1 as nchar(10)) as numeric(38,10)); 
select cast(cast(-1.1 as nchar varying(10)) as numeric(38,10)); 
select cast(cast('  -1.1   ' as char(10)) as numeric(38,10));
select cast(cast('  -1.1' as char(10)) as numeric(38,10));
select cast(cast('-1.1   ' as char(10)) as numeric(38,10));
select cast(cast('  -1.1   ' as char varying(10)) as numeric(38,10));
select cast(cast('  -1.1' as char varying(10)) as numeric(38,10));
select cast(cast('-1.1   ' as char varying(10)) as numeric(38,10));
select cast('  -1.1   ' as numeric(38,10));
select cast('  -1.1' as numeric(38,10));
select cast('-1.1   ' as numeric(38,10));

--error
select cast(cast('1.1a' as char(10)) as numeric(38,10));
select cast(cast('1.1a' as char varying(10)) as numeric(38,10));
select cast(cast('a1.1' as char(10)) as numeric(38,10));
select cast(cast('a1.1' as char varying(10)) as numeric(38,10));
select cast(cast('1a1.1' as char(10)) as numeric(38,10));
select cast(cast('1a1.1' as char varying(10)) as numeric(38,10));

select cast(cast('1+1.1' as char(10)) as numeric(38,10));
select cast(cast('1+1.1' as char varying(10)) as numeric(38,10));
select cast(cast('1*1.1' as char(10)) as numeric(38,10));
select cast(cast('1*1.1' as char varying(10)) as numeric(38,10));
select cast(cast('1-1.1' as char(10)) as numeric(38,10));
select cast(cast('1-1.1' as char varying(10)) as numeric(38,10));
select cast(cast('1/1.1' as char(10)) as numeric(38,10));
select cast(cast('1/1.1' as char varying(10)) as numeric(38,10));

select cast(cast('1 1.1' as char(10)) as numeric(38,10));
select cast(cast('1 1.1' as char varying(10)) as numeric(38,10));
select cast(cast('11. 1' as char(10)) as numeric(38,10));
select cast(cast('11. 1' as char varying(10)) as numeric(38,10));
select cast(cast('11 .1' as char(10)) as numeric(38,10));
select cast(cast('11 .1' as char varying(10)) as numeric(38,10));
select cast(cast('11.1 1' as char(10)) as numeric(38,10));
select cast(cast('11.1 1' as char varying(10)) as numeric(38,10));

-- return NULL
select cast(NULL as numeric(38,10));
select cast(cast('' as char(10)) as numeric(38,10));
select cast(cast('' as char varying(10)) as numeric(38,10));
select cast(cast('     ' as char(10)) as numeric(38,10));
select cast(cast('     ' as char varying(10)) as numeric(38,10));

