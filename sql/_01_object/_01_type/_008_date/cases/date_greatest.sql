
-- datetime , other

select greatest(datetime'01/01/2000', datetime'01/02/2000');

select greatest(datetime'01/01/2000', timestamp'01/02/2000');

select greatest(datetime'01/01/2000', date'01/02/2000');

select greatest(datetime'01/01/2000', time'00:00:00');

select greatest(datetime'01/01/2000', '01/02/2000 00:00:00.000');

select greatest(datetime'01/01/2000', '01/02/2000 00:00:00');

select greatest(datetime'01/01/2000', '01/02/2000');

select greatest(datetime'01/01/2000', '00:00:00');



-- timestamp , other

select greatest(timestamp'01/01/2000', datetime'01/02/2000');

select greatest(timestamp'01/01/2000', timestamp'01/02/2000');

select greatest(timestamp'01/01/2000', date'01/02/2000');

select greatest(timestamp'01/01/2000', time'00:00:00');

select greatest(timestamp'01/01/2000', '01/02/2000 00:00:00.000');

select greatest(timestamp'01/01/2000', '01/02/2000 00:00:00');

select greatest(timestamp'01/01/2000', '01/02/2000');

select greatest(timestamp'01/01/2000', '00:00:00');


-- date , other

select greatest(date'01/01/2000', datetime'01/02/2000');

select greatest(date'01/01/2000', timestamp'01/02/2000');

select greatest(date'01/01/2000', date'01/02/2000');

select greatest(date'01/01/2000', time'00:00:00');

select greatest(date'01/01/2000', '01/02/2000 00:00:00.000');

select greatest(date'01/01/2000', '01/02/2000 00:00:00');

select greatest(date'01/01/2000', '01/02/2000');

select greatest(date'01/01/2000', '00:00:00');


-- time , other

select greatest(time'00:00:00', datetime'01/02/2000');

select greatest(time'00:00:00', timestamp'01/02/2000');

select greatest(time'00:00:00', date'01/02/2000');

select greatest(time'00:00:00', time'00:00:00');

select greatest(time'00:00:00', '01/02/2000 00:00:00.000');

select greatest(time'00:00:00', '01/02/2000 00:00:00');

select greatest(time'00:00:00', '01/02/2000');

select greatest(time'00:00:00', '00:00:01');



-- datetime string, other

select greatest('01/01/2000 00:00:00.000', datetime'01/02/2000');

select greatest('01/01/2000 00:00:00.000', timestamp'01/02/2000');

select greatest('01/01/2000 00:00:00.000', date'01/02/2000');

select greatest('01/01/2000 00:00:00.000', time'00:00:00');

select greatest('01/01/2000 00:00:00.000', '01/02/2000 00:00:00.000');

select greatest('01/01/2000 00:00:00.000', '01/02/2000 00:00:00');

select greatest('01/01/2000 00:00:00.000', '01/02/2000');

select greatest('01/01/2000 00:00:00.000', '00:00:00');



-- timestamp string, other

select greatest('01/01/2000 00:00:00', datetime'01/02/2000');

select greatest('01/01/2000 00:00:00', timestamp'01/02/2000');

select greatest('01/01/2000 00:00:00', date'01/02/2000');

select greatest('01/01/2000 00:00:00', time'00:00:00');

select greatest('01/01/2000 00:00:00', '01/02/2000 00:00:00.000');

select greatest('01/01/2000 00:00:00', '01/02/2000 00:00:00');

select greatest('01/01/2000 00:00:00', '01/02/2000');

select greatest('01/01/2000 00:00:00', '00:00:00');


-- date string, other

select greatest('01/01/2000', datetime'01/02/2000');

select greatest('01/01/2000', timestamp'01/02/2000');

select greatest('01/01/2000', date'01/02/2000');

select greatest('01/01/2000', time'00:00:00');

select greatest('01/01/2000', '01/02/2000 00:00:00.000');

select greatest('01/01/2000', '01/02/2000 00:00:00');

select greatest('01/01/2000', '01/02/2000');

select greatest('01/01/2000', '00:00:00');


-- time string, other

select greatest('00:00:00', datetime'01/02/2000');

select greatest('00:00:00', timestamp'01/02/2000');

select greatest('00:00:00', date'01/02/2000');

select greatest('00:00:00', time'00:00:00');

select greatest('00:00:00', '01/02/2000 00:00:00.000');

select greatest('00:00:00', '01/02/2000 00:00:00');

select greatest('00:00:00', '01/02/2000');

select greatest('00:00:00', '00:00:01');

