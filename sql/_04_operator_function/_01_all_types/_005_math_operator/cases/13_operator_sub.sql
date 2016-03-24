select cast(3 as SHORT) - cast(2 as SHORT) from db_root;
select cast(3 as SHORT) - cast(2 as INTEGER) from db_root;
select cast(3 as SHORT) - cast(2 as BIGINT) from db_root;
select cast(3 as SHORT) - cast(2 as FLOAT) from db_root;
select cast(3 as SHORT) - cast(2 as DOUBLE) from db_root;
select cast(3 as SHORT) - cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as SHORT) - cast(2 as MONETARY) from db_root;

select cast(3 as INTEGER) - cast(2 as SHORT) from db_root;
select cast(3 as INTEGER) - cast(2 as INTEGER) from db_root;
select cast(3 as INTEGER) - cast(2 as BIGINT) from db_root;
select cast(3 as INTEGER) - cast(2 as FLOAT) from db_root;
select cast(3 as INTEGER) - cast(2 as DOUBLE) from db_root;
select cast(3 as INTEGER) - cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as INTEGER) - cast(2 as MONETARY) from db_root;

select cast(3 as BIGINT) - cast(2 as SHORT) from db_root;
select cast(3 as BIGINT) - cast(2 as INTEGER) from db_root;
select cast(3 as BIGINT) - cast(2 as BIGINT) from db_root;
select cast(3 as BIGINT) - cast(2 as FLOAT) from db_root;
select cast(3 as BIGINT) - cast(2 as DOUBLE) from db_root;
select cast(3 as BIGINT) - cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as BIGINT) - cast(2 as MONETARY) from db_root;

select cast(3 as FLOAT) - cast(2 as SHORT) from db_root;
select cast(3 as FLOAT) - cast(2 as INTEGER) from db_root;
select cast(3 as FLOAT) - cast(2 as BIGINT) from db_root;
select cast(3 as FLOAT) - cast(2 as FLOAT) from db_root;
select cast(3 as FLOAT) - cast(2 as DOUBLE) from db_root;
select cast(3 as FLOAT) - cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as FLOAT) - cast(2 as MONETARY) from db_root;

select cast(3 as DOUBLE) - cast(2 as SHORT) from db_root;
select cast(3 as DOUBLE) - cast(2 as INTEGER) from db_root;
select cast(3 as DOUBLE) - cast(2 as BIGINT) from db_root;
select cast(3 as DOUBLE) - cast(2 as FLOAT) from db_root;
select cast(3 as DOUBLE) - cast(2 as DOUBLE) from db_root;
select cast(3 as DOUBLE) - cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as DOUBLE) - cast(2 as MONETARY) from db_root;

select cast(3 as NUMERIC(15,5)) - cast(2 as SHORT) from db_root;
select cast(3 as NUMERIC(15,5)) - cast(2 as INTEGER) from db_root;
select cast(3 as NUMERIC(15,5)) - cast(2 as BIGINT) from db_root;
select cast(3 as NUMERIC(15,5)) - cast(2 as FLOAT) from db_root;
select cast(3 as NUMERIC(15,5)) - cast(2 as DOUBLE) from db_root;
select cast(3 as NUMERIC(15,5)) - cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as NUMERIC(15,5)) - cast(2 as MONETARY) from db_root;

select cast(3 as MONETARY) - cast(2 as SHORT) from db_root;
select cast(3 as MONETARY) - cast(2 as INTEGER) from db_root;
select cast(3 as MONETARY) - cast(2 as BIGINT) from db_root;
select cast(3 as MONETARY) - cast(2 as FLOAT) from db_root;
select cast(3 as MONETARY) - cast(2 as DOUBLE) from db_root;
select cast(3 as MONETARY) - cast(2 as NUMERIC(15,5)) from db_root;
select cast(3 as MONETARY) - cast(2 as MONETARY) from db_root;

-- underflow: min - 1
select cast(-32768 as SHORT) - cast(1 as SHORT) from db_root;
select cast(-32768 as SHORT) - cast(1 as INTEGER) from db_root;
select cast(-32768 as SHORT) - cast(1 as BIGINT) from db_root;
select cast(-32768 as SHORT) - cast(1 as NUMERIC(38)) from db_root;
select cast(-32768 as SHORT) - cast(1 as FLOAT) from db_root;
select cast(-32768 as SHORT) - cast(1 as DOUBLE) from db_root;
select cast(-32768 as SHORT) - cast(1 as MONETARY) from db_root;

select cast(-2147483648 as INTEGER) - cast(1 as SHORT) from db_root;
select cast(-2147483648 as INTEGER) - cast(1 as INTEGER) from db_root;
select cast(-2147483648 as INTEGER) - cast(1 as BIGINT) from db_root;
select cast(-2147483648 as INTEGER) - cast(1 as NUMERIC(38)) from db_root;
select cast(-2147483648 as INTEGER) - cast(1 as FLOAT) from db_root;
select cast(-2147483648 as INTEGER) - cast(1 as DOUBLE) from db_root;
select cast(-2147483648 as INTEGER) - cast(1 as MONETARY) from db_root;

select cast(-9223372036854775808 as BIGINT) - cast(1 as SHORT) from db_root;
select cast(-9223372036854775808 as BIGINT) - cast(1 as INTEGER) from db_root;
select cast(-9223372036854775808 as BIGINT) - cast(1 as BIGINT) from db_root;
select cast(-9223372036854775808 as BIGINT) - cast(1 as NUMERIC(38)) from db_root;
select cast(-9223372036854775808 as BIGINT) - cast(1 as FLOAT) from db_root;
select cast(-9223372036854775808 as BIGINT) - cast(1 as DOUBLE) from db_root;
select cast(-9223372036854775808 as BIGINT) - cast(1 as MONETARY) from db_root;

select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(1 as SHORT) from db_root;
select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(1 as INTEGER) from db_root;
select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(1 as BIGINT) from db_root;
select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(1 as NUMERIC(38)) from db_root;
select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(1 as FLOAT) from db_root;
select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(1 as DOUBLE) from db_root;
select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(1 as MONETARY) from db_root;

select cast(1.175494e-38 as FLOAT) - cast(1 as SHORT) from db_root;
select cast(1.175494e-38 as FLOAT) - cast(1 as INTEGER) from db_root;
select cast(1.175494e-38 as FLOAT) - cast(1 as BIGINT) from db_root;
select cast(1.175494e-38 as FLOAT) - cast(1 as NUMERIC(38)) from db_root;
select cast(1.175494e-38 as FLOAT) - cast(1 as FLOAT) from db_root;
select cast(1.175494e-38 as FLOAT) - cast(1 as DOUBLE) from db_root;
select cast(1.175494e-38 as FLOAT) - cast(1 as MONETARY) from db_root;

select cast(2.2250738585072014e-308 as DOUBLE) - cast(1 as SHORT) from db_root;
select cast(2.2250738585072014e-308 as DOUBLE) - cast(1 as INTEGER) from db_root;
select cast(2.2250738585072014e-308 as DOUBLE) - cast(1 as BIGINT) from db_root;
select cast(2.2250738585072014e-308 as DOUBLE) - cast(1 as NUMERIC(38)) from db_root;
select cast(2.2250738585072014e-308 as DOUBLE) - cast(1 as FLOAT) from db_root;
select cast(2.2250738585072014e-308 as DOUBLE) - cast(1 as DOUBLE) from db_root;
select cast(2.2250738585072014e-308 as DOUBLE) - cast(1 as MONETARY) from db_root;

select cast(2.2250738585072014e-308 as MONETARY) - cast(1 as SHORT) from db_root;
select cast(2.2250738585072014e-308 as MONETARY) - cast(1 as INTEGER) from db_root;
select cast(2.2250738585072014e-308 as MONETARY) - cast(1 as BIGINT) from db_root;
select cast(2.2250738585072014e-308 as MONETARY) - cast(1 as NUMERIC(38)) from db_root;
select cast(2.2250738585072014e-308 as MONETARY) - cast(1 as FLOAT) from db_root;
select cast(2.2250738585072014e-308 as MONETARY) - cast(1 as DOUBLE) from db_root;
select cast(2.2250738585072014e-308 as MONETARY) - cast(1 as MONETARY) from db_root;

-- underflow: min - max
select cast(-32768 as SHORT) - cast(32767 as SHORT) from db_root;
select cast(-32768 as SHORT) - cast(2147483647 as INTEGER) from db_root;
select cast(-32768 as SHORT) - cast(9223372036854775807 as BIGINT) from db_root;
select cast(-32768 as SHORT) - cast(99999999999999999999999999999999999999 as NUMERIC(38)) from db_root;
select cast(-32768 as SHORT) - cast(3.402823e+38 as FLOAT) from db_root;
select cast(-32768 as SHORT) - cast(1.7976931348623157e+308 as DOUBLE) from db_root;
select cast(-32768 as SHORT) - cast(1.7976931348623157e+308 as MONETARY) from db_root;

select cast(-2147483648 as INTEGER) - cast(32767 as SHORT) from db_root;
select cast(-2147483648 as INTEGER) - cast(2147483647 as INTEGER) from db_root;
select cast(-2147483648 as INTEGER) - cast(9223372036854775807 as BIGINT) from db_root;
select cast(-2147483648 as INTEGER) - cast(99999999999999999999999999999999999999 as NUMERIC(38)) from db_root;
select cast(-2147483648 as INTEGER) - cast(3.402823e+38 as FLOAT) from db_root;
select cast(-2147483648 as INTEGER) - cast(1.7976931348623157e+308 as DOUBLE) from db_root;
select cast(-2147483648 as INTEGER) - cast(1.7976931348623157e+308 as MONETARY) from db_root;

select cast(-9223372036854775808 as BIGINT) - cast(32767 as SHORT) from db_root;
select cast(-9223372036854775808 as BIGINT) - cast(2147483647 as INTEGER) from db_root;
select cast(-9223372036854775808 as BIGINT) - cast(9223372036854775807 as BIGINT) from db_root;
select cast(-9223372036854775808 as BIGINT) - cast(99999999999999999999999999999999999999 as NUMERIC(38)) from db_root;
select cast(-9223372036854775808 as BIGINT) - cast(3.402823e+38 as FLOAT) from db_root;
select cast(-9223372036854775808 as BIGINT) - cast(1.7976931348623157e+308 as DOUBLE) from db_root;
select cast(-9223372036854775808 as BIGINT) - cast(1.7976931348623157e+308 as MONETARY) from db_root;

select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(32767 as SHORT) from db_root;
select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(2147483647 as INTEGER) from db_root;
select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(9223372036854775807 as BIGINT) from db_root;
select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(99999999999999999999999999999999999999 as NUMERIC(38)) from db_root;
select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(3.402823e+38 as FLOAT) from db_root;
select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(1.7976931348623157e+308 as DOUBLE) from db_root;
select cast(-99999999999999999999999999999999999999 as NUMERIC(38)) - cast(1.7976931348623157e+308 as MONETARY) from db_root;

select cast(1.175494e-38 as FLOAT) - cast(32767 as SHORT) from db_root;
select cast(1.175494e-38 as FLOAT) - cast(2147483647 as INTEGER) from db_root;
select cast(1.175494e-38 as FLOAT) - cast(9223372036854775807 as BIGINT) from db_root;
select cast(1.175494e-38 as FLOAT) - cast(99999999999999999999999999999999999999 as NUMERIC(38)) from db_root;
select cast(1.175494e-38 as FLOAT) - cast(3.402823e+38 as FLOAT) from db_root;
select cast(1.175494e-38 as FLOAT) - cast(1.7976931348623157e+308 as DOUBLE) from db_root;
select cast(1.175494e-38 as FLOAT) - cast(1.7976931348623157e+308 as MONETARY) from db_root;

select cast(2.2250738585072014e-308 as DOUBLE) - cast(32767 as SHORT) from db_root;
select cast(2.2250738585072014e-308 as DOUBLE) - cast(2147483647 as INTEGER) from db_root;
select cast(2.2250738585072014e-308 as DOUBLE) - cast(9223372036854775807 as BIGINT) from db_root;
select cast(2.2250738585072014e-308 as DOUBLE) - cast(99999999999999999999999999999999999999 as NUMERIC(38)) from db_root;
select cast(2.2250738585072014e-308 as DOUBLE) - cast(3.402823e+38 as FLOAT) from db_root;
select cast(2.2250738585072014e-308 as DOUBLE) - cast(1.7976931348623157e+308 as DOUBLE) from db_root;
select cast(2.2250738585072014e-308 as DOUBLE) - cast(1.7976931348623157e+308 as MONETARY) from db_root;

select cast(2.2250738585072014e-308 as MONETARY) - cast(32767 as SHORT) from db_root;
select cast(2.2250738585072014e-308 as MONETARY) - cast(2147483647 as INTEGER) from db_root;
select cast(2.2250738585072014e-308 as MONETARY) - cast(9223372036854775807 as BIGINT) from db_root;
select cast(2.2250738585072014e-308 as MONETARY) - cast(99999999999999999999999999999999999999 as NUMERIC(38)) from db_root;
select cast(2.2250738585072014e-308 as MONETARY) - cast(3.402823e+38 as FLOAT) from db_root;
select cast(2.2250738585072014e-308 as MONETARY) - cast(1.7976931348623157e+308 as DOUBLE) from db_root;
select cast(2.2250738585072014e-308 as MONETARY) - cast(1.7976931348623157e+308 as MONETARY) from db_root;


