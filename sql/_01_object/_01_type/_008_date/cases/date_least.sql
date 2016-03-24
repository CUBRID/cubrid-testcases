
-- datetime , other

select least(datetime'01/01/2000', datetime'01/02/2000');

select least(datetime'01/01/2000', timestamp'01/02/2000');

select least(datetime'01/01/2000', date'01/02/2000');

select least(datetime'01/01/2000', time'00:00:00');

select least(datetime'01/01/2000', '01/02/2000 00:00:00.000');

select least(datetime'01/01/2000', '01/02/2000 00:00:00');

select least(datetime'01/01/2000', '01/02/2000');

select least(datetime'01/01/2000', '00:00:00');



-- timestamp , other

select least(timestamp'01/01/2000', datetime'01/02/2000');

select least(timestamp'01/01/2000', timestamp'01/02/2000');

select least(timestamp'01/01/2000', date'01/02/2000');

select least(timestamp'01/01/2000', time'00:00:00');

select least(timestamp'01/01/2000', '01/02/2000 00:00:00.000');

select least(timestamp'01/01/2000', '01/02/2000 00:00:00');

select least(timestamp'01/01/2000', '01/02/2000');

select least(timestamp'01/01/2000', '00:00:00');


-- date , other

select least(date'01/01/2000', datetime'01/02/2000');

select least(date'01/01/2000', timestamp'01/02/2000');

select least(date'01/01/2000', date'01/02/2000');

select least(date'01/01/2000', time'00:00:00');

select least(date'01/01/2000', '01/02/2000 00:00:00.000');

select least(date'01/01/2000', '01/02/2000 00:00:00');

select least(date'01/01/2000', '01/02/2000');

select least(date'01/01/2000', '00:00:00');


-- time , other

select least(time'00:00:00', datetime'01/02/2000');

select least(time'00:00:00', timestamp'01/02/2000');

select least(time'00:00:00', date'01/02/2000');

select least(time'00:00:00', time'00:00:00');

select least(time'00:00:00', '01/02/2000 00:00:00.000');

select least(time'00:00:00', '01/02/2000 00:00:00');

select least(time'00:00:00', '01/02/2000');

select least(time'00:00:00', '00:00:01');



-- datetime string, other

select least('01/01/2000 00:00:00.000', datetime'01/02/2000');

select least('01/01/2000 00:00:00.000', timestamp'01/02/2000');

select least('01/01/2000 00:00:00.000', date'01/02/2000');

select least('01/01/2000 00:00:00.000', time'00:00:00');

select least('01/01/2000 00:00:00.000', '01/02/2000 00:00:00.000');

select least('01/01/2000 00:00:00.000', '01/02/2000 00:00:00');

select least('01/01/2000 00:00:00.000', '01/02/2000');

select least('01/01/2000 00:00:00.000', '00:00:00');



-- timestamp string, other

select least('01/01/2000 00:00:00', datetime'01/02/2000');

select least('01/01/2000 00:00:00', timestamp'01/02/2000');

select least('01/01/2000 00:00:00', date'01/02/2000');

select least('01/01/2000 00:00:00', time'00:00:00');

select least('01/01/2000 00:00:00', '01/02/2000 00:00:00.000');

select least('01/01/2000 00:00:00', '01/02/2000 00:00:00');

select least('01/01/2000 00:00:00', '01/02/2000');

select least('01/01/2000 00:00:00', '00:00:00');


-- date string, other

select least('01/01/2000', datetime'01/02/2000');

select least('01/01/2000', timestamp'01/02/2000');

select least('01/01/2000', date'01/02/2000');

select least('01/01/2000', time'00:00:00');

select least('01/01/2000', '01/02/2000 00:00:00.000');

select least('01/01/2000', '01/02/2000 00:00:00');

select least('01/01/2000', '01/02/2000');

select least('01/01/2000', '00:00:00');


-- time string, other

select least('00:00:00', datetime'01/02/2000');

select least('00:00:00', timestamp'01/02/2000');

select least('00:00:00', date'01/02/2000');

select least('00:00:00', time'00:00:00');

select least('00:00:00', '01/02/2000 00:00:00.000');

select least('00:00:00', '01/02/2000 00:00:00');

select least('00:00:00', '01/02/2000');

select least('00:00:00', '00:00:01');

