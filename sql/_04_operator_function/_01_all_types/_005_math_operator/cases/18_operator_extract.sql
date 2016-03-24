-- time
select extract(HOUR from TIME '01:02:03 am') from db_root;
select extract(MINUTE from TIME '01:02:03 am') from db_root;
select extract(SECOND from TIME '01:02:03 am') from db_root;
