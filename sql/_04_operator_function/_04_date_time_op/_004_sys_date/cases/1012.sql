--test '05/26/2008', '14:24:00', '14:24:00 05/26/2008' with operator -
select date'05/26/2008'-to_date('5/5/2008') from db_root;
select time'14:24:00'-to_time('8:8:8 am') from db_root;
select timestamp'14:24:00 05/26/2008'-to_timestamp('5/5/2008 8:8:8 am') from db_root;
