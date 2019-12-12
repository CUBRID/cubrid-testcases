create table g(i smallint, j int, k bigint);
insert into g values(-32768, -2147483648,-9223372036854775808);
insert into g values(-32768, -2147483648,-9223372036854775808);

select bit_and(i) from g;
select bit_and(j) from g;
select bit_and(k) from g;

select bit_or(i) from g;
select bit_or(j) from g;
select bit_or(k) from g;

select BIT_XOR(i) from g;
select BIT_XOR(j) from g;
select BIT_XOR(k) from g;

select ~i from g;
select ~j from g;
select ~k from g;

select i>>2 from g;
select j>>2 from g;
select k>>2 from g;

select i%i from g;
select j%2 from g;
select k%2 from g;


select -32768 & 2 from g;
select -2147483648 & 2 from g;
select -9223372036854775808 & 2 from g;

select -32768 | 2 from g;
select -2147483648 | 2 from g;
select -9223372036854775808 | 2 from g;

select (-32768)^2 from g;
select (-2147483648)^2 from g;
select (-9223372036854775808)^2 from g;

select ~(-32768) from g;
select ~(-2147483648) from g;
select ~(-9223372036854775808) from g;

select (-32768)>>2 from g;
select (-2147483648)>>2 from g;
select (-9223372036854775808)>>2 from g;

select -32768%2 from g;
select -2147483648%2 from g;
select -9223372036854775808%2 from g;
drop table g;
