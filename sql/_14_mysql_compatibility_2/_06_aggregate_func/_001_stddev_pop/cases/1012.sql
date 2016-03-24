--test STDDEV_POP function with constant of numeric type
select STDDEV_POP(20) from db_root;
select STDDEV_POP(20.23) from db_root;
