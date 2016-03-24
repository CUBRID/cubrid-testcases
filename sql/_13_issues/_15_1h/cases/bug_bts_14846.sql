--[TimeZone] Timetz/Timeltz data types are not included in '_db_data_type' system table.


select * from _db_data_type order by 1;
select * from _db_data_type order by 1 desc;

select * from _db_data_type where type_name like '%tz' order by 1;
select * from _db_data_type where type_name like '%TZ' order by 1;
