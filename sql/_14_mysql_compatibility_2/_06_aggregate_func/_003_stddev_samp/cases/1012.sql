--test STDDEV_SAMP function with constant of numeric type
select STDDEV_SAMP(20) from db_root;
select STDDEV_SAMP(20.23) from db_root;
