select if(to_char(datetime'01-01-01 12:30:30 AM', 'HH') = '12', 'OK', 'NOK');
select if(to_char(timestamp'01-01-01 12:30:30 AM', 'HH') = '12', 'OK', 'NOK');
select if(to_char(time'12:30:30 AM', 'HH') = '12', 'OK', 'NOK');

select if(to_char(datetime'01-01-01 12:30:30 AM', 'HH12') = '12', 'OK', 'NOK');
select if(to_char(timestamp'01-01-01 12:30:30 AM', 'HH12') = '12', 'OK', 'NOK');
select if(to_char(time'12:30:30 AM', 'HH12') = '12', 'OK', 'NOK');

select if(to_char(datetime'01-01-01 12:30:30 PM', 'HH') = '12', 'OK', 'NOK');
select if(to_char(timestamp'01-01-01 12:30:30 PM', 'HH') = '12', 'OK', 'NOK');
select if(to_char(time'12:30:30 PM', 'HH') = '12', 'OK', 'NOK');

select if(to_char(datetime'01-01-01 12:30:30 AM', 'HH24') = '00', 'OK', 'NOK');
select if(to_char(timestamp'01-01-01 12:30:30 AM', 'HH24') = '00', 'OK', 'NOK');
select if(to_char(time'12:30:30 AM', 'HH24') = '00', 'OK', 'NOK');

select if(to_char(datetime'01-01-01 12:30:30 PM', 'HH24') = '12', 'OK', 'NOK');
select if(to_char(timestamp'01-01-01 12:30:30 PM', 'HH24') = '12', 'OK', 'NOK');
select if(to_char(time'12:30:30 PM', 'HH24') = '12', 'OK', 'NOK');


select if(to_char(datetime'01-01-01 23:30:30', 'HH') = '11', 'OK', 'NOK');
select if(to_char(timestamp'01-01-01 23:30:30', 'HH') = '11', 'OK', 'NOK');
select if(to_char(time'23:30:30', 'HH') = '11', 'OK', 'NOK');

select if(to_char(datetime'01-01-01 11:30:30 PM', 'HH') = '11', 'OK', 'NOK');
select if(to_char(timestamp'01-01-01 11:30:30 PM', 'HH') = '11', 'OK', 'NOK');
select if(to_char(time'11:30:30 PM', 'HH') = '11', 'OK', 'NOK');

select if(to_char(datetime'01-01-01 23:30:30', 'HH24') = '23', 'OK', 'NOK');
select if(to_char(timestamp'01-01-01 23:30:30', 'HH24') = '23', 'OK', 'NOK');
select if(to_char(time'23:30:30', 'HH24') = '23', 'OK', 'NOK');

select if(to_char(datetime'01-01-01 11:30:30 PM', 'HH24') = '23', 'OK', 'NOK');
select if(to_char(timestamp'01-01-01 11:30:30 PM', 'HH24') = '23', 'OK', 'NOK');
select if(to_char(time'11:30:30 PM', 'HH24') = '23', 'OK', 'NOK');
