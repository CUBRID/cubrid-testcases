--to cover qdata_bit_and_dbval(), run cases as: 
create table g(i smallint, j int, k bigint);
insert into g values(-32768, -2147483648,-9223372036854775808);
insert into g values(-32768, -2147483648,-9223372036854775808);

select bit_and(i) from g;
select bit_and(j) from g;
select bit_and(k) from g;

drop table g;

-- to cover qdata_bit_or_dbval(), run cases as:
create table g(i smallint, j int, k bigint);
insert into g values(-32768, -2147483648,-9223372036854775808);
insert into g values(-32768, -2147483648,-9223372036854775808);

select bit_or(i) from g;
select bit_or(j) from g;
select bit_or(k) from g;
drop table g;

-- to cover qdata_bit_xor_dbval(), run cases as:
create table g(i smallint, j int, k bigint);
insert into g values(-32768, -2147483648,-9223372036854775808);
insert into g values(-32768, -2147483648,-9223372036854775808);

select BIT_XOR(i) from g;
select BIT_XOR(j) from g;
select BIT_XOR(k) from g;

drop table g;
--to cover qdata_bit_not_dbval()*, run cases as:
create table g(i smallint, j int, k bigint);
insert into g values(-32768, -2147483648,-9223372036854775808);
insert into g values(-32768, -2147483648,-9223372036854775808);

select i>>2 from g;
select j>>2 from g;
select k>>2 from g;

drop table g;

--to cover qdata_bit_shift_dbval(), run cases as:
create table g(i smallint, j int, k bigint);
insert into g values(-32768, -2147483648,-9223372036854775808);
insert into g values(-32768, -2147483648,-9223372036854775808);

select i>>2 from g;
select j>>2 from g;
select k>>2 from g;

drop table g;

--to cover qdata_divmod_dbval(), run cases as:
create table g(i smallint, j int, k bigint);
insert into g values(-32768, -2147483648,-9223372036854775808);
insert into g values(-32768, -2147483648,-9223372036854775808);

select i%2 from g;
select j%2 from g;
select k%2 from g;
drop table g;
--to cover pt_evaluate_db_value_expr(), run cases as:
create table g(i int);
insert into g values(1);

select -32768 & cast(2 as smallint) from g;
select -2147483648 & 2 from g;
select -9223372036854775808 & 2 from g;

select -32768 | cast(2 as smallint) from g;
select -2147483648 | 2 from g;
select -9223372036854775808 | 2 from g;

select (-32768)^cast(2 as smallint) from g;
select (-2147483648)^2 from g;
select (-9223372036854775808)^2 from g;

select ~(-32768) from g;
select ~(-2147483648) from g;
select ~(-9223372036854775808) from g;

select (-32768)>> cast(2 as smallint) from g;
select (-2147483648)>>2 from g;
select (-9223372036854775808)>>2 from g;

select -32768% cast(2 as smallint) from g;
select -2147483648%2 from g;
select -9223372036854775808%2 from g;

drop table g;
