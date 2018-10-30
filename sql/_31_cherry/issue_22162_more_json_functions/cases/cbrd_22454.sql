select cast('true' as json);
select cast('TRUE' as json);
select cast('True' as json);

select cast('false' as json);
select cast('FALSE' as json);
select cast('False' as json);

select cast(cast('true' as json) as string);
select cast(cast('true' as json) as varchar);
select cast(cast('true' as json) as char(4));
select cast(cast('true' as json) as char(2));

select cast(cast('true' as json) as smallint);
select cast(cast('true' as json) as bigint);
select cast(cast('true' as json) as numeric);
select cast(cast('true' as json) as int);

select cast(cast('false' as json) as string);
select cast(cast('false' as json) as varchar);
select cast(cast('false' as json) as char(5));
select cast(cast('false' as json) as char(2));

select cast(cast('false' as json) as smallint);
select cast(cast('false' as json) as bigint);
select cast(cast('false' as json) as numeric);
select cast(cast('false' as json) as int);


