select not w from (select 0 w union select 1) w;
select (not w) from (select 0 w union select 1) w;
