--test translate with to_char and types date, time, timestamp
select translate(to_char(date'8/8/2008'), '8', '1') from db_root;
select translate(to_char(time'8:8:8 am'), '8', '1') from db_root;
select translate(to_char(timestamp'8/8/2008 8:8:8 am'), '8', '1') from db_root order by 1;