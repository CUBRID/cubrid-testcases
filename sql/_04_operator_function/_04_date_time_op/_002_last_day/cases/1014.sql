--tests last_day using to_date, to_char 
select to_date(to_char(last_day(date'2/1/2008'))) from db_root;
