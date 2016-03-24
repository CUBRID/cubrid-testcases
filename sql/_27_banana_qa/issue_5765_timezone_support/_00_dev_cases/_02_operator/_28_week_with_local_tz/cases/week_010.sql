--marginal values of timestampltz/datetimeltz type (2 params)


--1. marginal values: timestampltz argument
--select week(timestampltz'00:00:00 01/01', 4);
select if(week(timestampltz'00:00:00 01/01/2014',4)=week(timestamptz'00:00:00 01/01/2014',4),'ok','nok');

select week(timestampltz'03:14:07 1/19/2038', 5);

select week(timestampltz'0:0:0 PM 1970-01-01', 6);

select week(timestampltz'1/19/2038 03:14:07 pm', 7);



--2. marginal values: datetimeltz argument
--select week(datetimeltz'0:0:0.00 1/1', 0);
select if(week(datetimeltz'0:0:0.00 1/1',0)=week(concat('01/01/',year(sysdate))),'ok','nok');

select week(datetimeltz'23:59:59.999 12/31/9999', 2);

select week(datetimeltz'00:00:00.0000 AM 0001-01-01', 4);

select week(datetimeltz'12/31/9999 23:59:59.999', 6);
