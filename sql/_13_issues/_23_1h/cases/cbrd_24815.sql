/* Description
The precision of the NUMERIC type is set differently for SMALLINT, INT, and BIGINT types.
bigint   -> numeric (19, ?) : DB_BIGINT_PRECISION 
int      -> numeric (10, ?) : DB_INTEGER_PRECISION 
smallint -> numeric (5, ?)  : DB_SMALLINT_PRECISION 
*/

select 9223372036854775807 / cast (10 as numeric) as "bigint_max",
        typeof (9223372036854775807 / cast (10 as numeric)) as "type";

select 2147483647 / cast (10 as numeric) as "int_max",
        typeof (cast (2147483647 as int) / cast (10 as numeric)) as "type";

select 32767 / cast (10 as numeric) as "smallint_max",
        typeof (cast (32767 as smallint) / cast (10 as numeric)) as "type";
