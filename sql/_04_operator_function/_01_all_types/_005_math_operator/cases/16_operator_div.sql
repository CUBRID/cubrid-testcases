select cast(3 as SHORT) / cast(2 as SHORT) from db_root;
select cast(3 as SHORT) / cast(2 as INTEGER) from db_root;
select cast(3 as SHORT) / cast(2 as BIGINT) from db_root;
select cast(3 as SHORT) / cast(2 as FLOAT) from db_root;
select cast(3 as SHORT) / cast(2 as DOUBLE) from db_root;
select cast(3 as SHORT) / cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as SHORT) / cast(2 as MONETARY) from db_root;

select cast(3 as INTEGER) / cast(2 as SHORT) from db_root;
select cast(3 as INTEGER) / cast(2 as INTEGER) from db_root;
select cast(3 as INTEGER) / cast(2 as BIGINT) from db_root;
select cast(3 as INTEGER) / cast(2 as FLOAT) from db_root;
select cast(3 as INTEGER) / cast(2 as DOUBLE) from db_root;
select cast(3 as INTEGER) / cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as INTEGER) / cast(2 as MONETARY) from db_root;

select cast(3 as BIGINT) / cast(2 as SHORT) from db_root;
select cast(3 as BIGINT) / cast(2 as INTEGER) from db_root;
select cast(3 as BIGINT) / cast(2 as BIGINT) from db_root;
select cast(3 as BIGINT) / cast(2 as FLOAT) from db_root;
select cast(3 as BIGINT) / cast(2 as DOUBLE) from db_root;
select cast(3 as BIGINT) / cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as BIGINT) / cast(2 as MONETARY) from db_root;

select cast(3 as FLOAT) / cast(2 as SHORT) from db_root;
select cast(3 as FLOAT) / cast(2 as INTEGER) from db_root;
select cast(3 as FLOAT) / cast(2 as BIGINT) from db_root;
select cast(3 as FLOAT) / cast(2 as FLOAT) from db_root;
select cast(3 as FLOAT) / cast(2 as DOUBLE) from db_root;
select cast(3 as FLOAT) / cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as FLOAT) / cast(2 as MONETARY) from db_root;

select cast(3 as DOUBLE) / cast(2 as SHORT) from db_root;
select cast(3 as DOUBLE) / cast(2 as INTEGER) from db_root;
select cast(3 as DOUBLE) / cast(2 as BIGINT) from db_root;
select cast(3 as DOUBLE) / cast(2 as FLOAT) from db_root;
select cast(3 as DOUBLE) / cast(2 as DOUBLE) from db_root;
select cast(3 as DOUBLE) / cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as DOUBLE) / cast(2 as MONETARY) from db_root;

select cast(3 as NUMERIC(15,5)) / cast(2 as SHORT) from db_root;
select cast(3 as NUMERIC(15,5)) / cast(2 as INTEGER) from db_root;
select cast(3 as NUMERIC(15,5)) / cast(2 as BIGINT) from db_root;
select cast(3 as NUMERIC(15,5)) / cast(2 as FLOAT) from db_root;
select cast(3 as NUMERIC(15,5)) / cast(2 as DOUBLE) from db_root;
select cast(3 as NUMERIC(15,5)) / cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as NUMERIC(15,5)) / cast(2 as MONETARY) from db_root;

select cast(3 as MONETARY) / cast(2 as SHORT) from db_root;
select cast(3 as MONETARY) / cast(2 as INTEGER) from db_root;
select cast(3 as MONETARY) / cast(2 as BIGINT) from db_root;
select cast(3 as MONETARY) / cast(2 as FLOAT) from db_root;
select cast(3 as MONETARY) / cast(2 as DOUBLE) from db_root;
select cast(3 as MONETARY) / cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as MONETARY) / cast(2 as MONETARY) from db_root;

-- div by 0
select cast(1 as numeric) / cast(0 as numeric)  from db_root;

-- overflow
select cast(3.402823e+38 as FLOAT) / cast(0.5 as FLOAT) from db_root;
select cast(1.7976931348623157e+308 as DOUBLE) / cast(0.5 as DOUBLE) from db_root;
select cast(1.7976931348623157e+308 as MONETARY) / cast(0.5 as MONETARY) from db_root;

select cast(32767 as SHORT) / cast(0.00000000000000000000000000000000000001 as NUMERIC(38,38)) from db_root;
select cast(2147483647 as INTEGER) / cast(0.00000000000000000000000000000000000001 as NUMERIC(38,38)) from db_root;
select cast(9223372036854775807 as BIGINT) / cast(0.00000000000000000000000000000000000001 as NUMERIC(38,38)) from db_root;

select cast(99999999999999999999999999999999999999 as NUMERIC(38)) / cast(0.5 as NUMERIC(5,1)) from db_root;

