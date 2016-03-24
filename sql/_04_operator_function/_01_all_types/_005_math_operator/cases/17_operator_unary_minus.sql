-- normal case (positive -> negative)
select -(cast(1 as SHORT)) from db_root;
select -(cast(1 as INTEGER)) from db_root;
select -(cast(1 as BIGINT)) from db_root;
select -(cast(1 as FLOAT)) from db_root;
select -(cast(1 as DOUBLE)) from db_root;
select -(cast(1 as NUMERIC(15,5))) from db_root;
select -(cast(1 as MONETARY)) from db_root;

-- normal case (negative -> positive)
select -(cast(-1 as SHORT)) from db_root;
select -(cast(-1 as INTEGER)) from db_root;
select -(cast(-1 as BIGINT)) from db_root;
select -(cast(-1 as FLOAT)) from db_root;
select -(cast(-1 as DOUBLE)) from db_root;
select -(cast(-1 as NUMERIC(15,5))) from db_root;
select -(cast(-1 as MONETARY)) from db_root;

-- normal case (zero)
select -(cast(0 as SHORT)) from db_root;
select -(cast(0 as INTEGER)) from db_root;
select -(cast(0 as BIGINT)) from db_root;
select -(cast(0 as FLOAT)) from db_root;
select -(cast(0 as DOUBLE)) from db_root;
select -(cast(0 as NUMERIC(15,5))) from db_root;
select -(cast(0 as MONETARY)) from db_root;

-- test MIN value
select -(cast(-32768 as SHORT)) from db_root;
select -(cast(-2147483648 as INTEGER)) from db_root;
select -(cast(-9223372036854775808 as BIGINT)) from db_root;
select -(cast(-99999999999999999999999999999999999999 as NUMERIC(38))) from db_root;




