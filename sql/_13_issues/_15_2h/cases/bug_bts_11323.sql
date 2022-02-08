select not w from (select 0 w union select 1) w;
select (not w<>0) from (select 0 w union select 1) w;
