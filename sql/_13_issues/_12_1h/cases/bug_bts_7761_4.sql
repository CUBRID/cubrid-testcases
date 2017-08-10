drop table if exists t;

create table t ( int_col int, float_col float, string_col varchar(100), time_col time, datetime_col datetime);
				
create index i_t_mi on t (mod (int_col, 2));
create index i_t_pf on t (power (float_col, 3.0));
create index i_t_dfcol on t (timediff (datetime_col, date'2010-01-01'));
create index i_t_dtcol on t (timediff (datetime_col, datetime'2010-01-01 12:34:56'));
create index i_t_tdcol on t (timediff (datetime_col, timestamp'2010-01-01 12:34:56'));
create index i_t_td2col on t (timediff (time_col, time'12:00:00'));
create index i_t_rpcol on t (replace (string_col, 'b', 'c'));

show indexes from t;

drop index i_t_mi on t (mod (int_col, 2));
drop index i_t_pf on t (power (float_col, 3.0));
drop index i_t_dtcol on t (timediff (datetime_col, date'2010-01-01 12:34:56'));
drop index i_t_dtcol on t (timediff (datetime_col, datetime'2010-01-01 12:34:56'));
drop index i_t_tdcol on t (timediff (datetime_col, timestamp'2010-01-01 12:34:56'));
drop index i_t_td2col on t (timediff (time_col, time'12:00:00'));
drop index i_t_rpcol on t (replace (string_col, 'b', 'c'));

show indexes from t;

drop table t;