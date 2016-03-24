select cast ( cast('12' as char(8)) as bigint);

select cast ( cast('12.5' as char(8)) as bigint);

select cast ( ' 12 ' as bigint);

select cast ( ' 12.5 ' as bigint);

select cast ( ' 12.45 ' as bigint);

select cast ( ' -12 ' as bigint);

select cast ( ' -12.5 ' as bigint);

select cast ( ' -12.45 ' as bigint);

select cast ( ' 0.5 ' as bigint);

select cast ( ' -0.5 ' as bigint);

select cast ( ' 0.45 ' as bigint);

select cast ( ' -0.45 ' as bigint);

select cast ('9223372036854775807' as bigint);

select cast ('9223372036854775807 ' as bigint);

select cast ('-9223372036854775808' as bigint);

select cast ('-9223372036854775808 ' as bigint);

select cast ('9223372036854775808' as bigint);

select cast ('9223372036854775808 ' as bigint);

select cast ('-9223372036854775809' as bigint);

select cast ('-9223372036854775809 ' as bigint);

select cast (' 9223372036854775807.45 ' as bigint);

select cast (' 9223372036854775807.5 ' as bigint);

select cast (' -9223372036854775808.45 ' as bigint);

select cast (' -9223372036854775808.5 ' as bigint);

