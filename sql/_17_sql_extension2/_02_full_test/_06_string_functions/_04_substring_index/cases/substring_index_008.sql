--pass marginal and out-of-range values


--pass 0 to count, an empty string should be returned
select substring_index('aaa-bbb-ccc-ddd-eee', '-', 0);

--count = the count of the delim
select substring_index('aaa-bbb-ccc-ddd-eee', '-', 4);
select substring_index('aaa-bbb-ccc-ddd-eee', '-', -4);

--count > the count of the delim
select substring_index('aaa-bbb-ccc-ddd-eee', '-', 20);
select substring_index('aaa-bbb-ccc-ddd-eee', '-', -200);

--pass out-of-range date/time value
select substring_index(date'10000-12-12', '-', 2);
select substring_index(time'15:78:12', ':', 2);
select substring_index(datetime'2009-14-12 12:13:14.123', ':', 1);
select substring_index(timestamp'28:13:33 pm 10/10/2010', '/', 2);



