

-- datetime, other

select nullif(datetime'01/01/2000', datetime'01/02/2000');

select nullif(datetime'01/01/2000', timestamp'01/02/2000');

select nullif(datetime'01/01/2000', date'01/02/2000');

select nullif(datetime'01/01/2000', time'00:00:00');

select nullif(datetime'01/01/2000', '01/02/2000 00:00:00.000');

select nullif(datetime'01/01/2000', '01/02/2000 00:00:00');

select nullif(datetime'01/01/2000', '01/02/2000');

select nullif(datetime'01/01/2000', '00:00:00');


-- timestamp, other

select nullif(timestamp'01/01/2000', datetime'01/02/2000');

select nullif(timestamp'01/01/2000', timestamp'01/02/2000');

select nullif(timestamp'01/01/2000', date'01/02/2000');

select nullif(timestamp'01/01/2000', time'00:00:00');

select nullif(timestamp'01/01/2000', '01/02/2000 00:00:00.000');

select nullif(timestamp'01/01/2000', '01/02/2000 00:00:00');

select nullif(timestamp'01/01/2000', '01/02/2000');

select nullif(timestamp'01/01/2000', '00:00:00');


-- date, other

select nullif(date'01/01/2000', datetime'01/02/2000');

select nullif(date'01/01/2000', timestamp'01/02/2000');

select nullif(date'01/01/2000', date'01/02/2000');

select nullif(date'01/01/2000', time'00:00:00');

select nullif(date'01/01/2000', '01/02/2000 00:00:00.000');

select nullif(date'01/01/2000', '01/02/2000 00:00:00');

select nullif(date'01/01/2000', '01/02/2000');

select nullif(date'01/01/2000', '00:00:00');


-- time, other

select nullif(time'00:00:00', datetime'01/02/2000');

select nullif(time'00:00:00', timestamp'01/02/2000');

select nullif(time'00:00:00', date'01/02/2000');

select nullif(time'00:00:00', time'00:00:00');

select nullif(time'00:00:00', '01/02/2000 00:00:00.000');

select nullif(time'00:00:00', '01/02/2000 00:00:00');

select nullif(time'00:00:00', '01/02/2000');

select nullif(time'00:00:00', '00:00:00');


