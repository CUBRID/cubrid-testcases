

-- datetime, other

select coalesce(datetime'01/01/2000', datetime'01/02/2000');

select coalesce(datetime'01/01/2000', timestamp'01/02/2000');

select coalesce(datetime'01/01/2000', date'01/02/2000');

select coalesce(datetime'01/01/2000', time'00:00:00');

select coalesce(datetime'01/01/2000', '01/02/2000 00:00:00.000');

select coalesce(datetime'01/01/2000', '01/02/2000 00:00:00');

select coalesce(datetime'01/01/2000', '01/02/2000');

select coalesce(datetime'01/01/2000', '00:00:00');


-- timestamp, other

select coalesce(timestamp'01/01/2000', datetime'01/02/2000');

select coalesce(timestamp'01/01/2000', timestamp'01/02/2000');

select coalesce(timestamp'01/01/2000', date'01/02/2000');

select coalesce(timestamp'01/01/2000', time'00:00:00');

select coalesce(timestamp'01/01/2000', '01/02/2000 00:00:00.000');

select coalesce(timestamp'01/01/2000', '01/02/2000 00:00:00');

select coalesce(timestamp'01/01/2000', '01/02/2000');

select coalesce(timestamp'01/01/2000', '00:00:00');


-- date, other

select coalesce(date'01/01/2000', datetime'01/02/2000');

select coalesce(date'01/01/2000', timestamp'01/02/2000');

select coalesce(date'01/01/2000', date'01/02/2000');

select coalesce(date'01/01/2000', time'00:00:00');

select coalesce(date'01/01/2000', '01/02/2000 00:00:00.000');

select coalesce(date'01/01/2000', '01/02/2000 00:00:00');

select coalesce(date'01/01/2000', '01/02/2000');

select coalesce(date'01/01/2000', '00:00:00');


-- time, other

select coalesce(time'00:00:00', datetime'01/02/2000');

select coalesce(time'00:00:00', timestamp'01/02/2000');

select coalesce(time'00:00:00', date'01/02/2000');

select coalesce(time'00:00:00', time'00:00:00');

select coalesce(time'00:00:00', '01/02/2000 00:00:00.000');

select coalesce(time'00:00:00', '01/02/2000 00:00:00');

select coalesce(time'00:00:00', '01/02/2000');

select coalesce(time'00:00:00', '00:00:00');


