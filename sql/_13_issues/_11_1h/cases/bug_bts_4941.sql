select time(cast(12345.67 as varchar)), time(cast(54321 as varchar)) from db_root;
select time(cast(12345.67 as varchar)), cast(54321 as varchar) from db_root;
