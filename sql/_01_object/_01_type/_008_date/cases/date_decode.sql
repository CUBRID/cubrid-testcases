

-- datetime, other

select decode(datetime'01/01/2000', datetime'01/01/2000', 'ok' , 'nok');

select decode(datetime'01/01/2000', timestamp'01/01/2000', 'ok' , 'nok');

select decode(datetime'01/01/2000', date'01/01/2000', 'ok' , 'nok');

select decode(datetime'01/01/2000', time'00:00:00', 'ok' , 'nok');

select decode(datetime'01/01/2000', '01/01/2000 00:00:00.000', 'ok' , 'nok');

select decode(datetime'01/01/2000', '01/01/2000 00:00:00', 'ok' , 'nok');

select decode(datetime'01/01/2000', '01/01/2000', 'ok' , 'nok');

select decode(datetime'01/01/2000', '00:00:00', 'ok' , 'nok');






-- timestamp, other

select decode(timestamp'01/01/2000', datetime'01/01/2000', 'ok' , 'nok');

select decode(timestamp'01/01/2000', timestamp'01/01/2000', 'ok' , 'nok');

select decode(timestamp'01/01/2000', date'01/01/2000', 'ok' , 'nok');

select decode(timestamp'01/01/2000', time'00:00:00', 'ok' , 'nok');

select decode(timestamp'01/01/2000', '01/01/2000 00:00:00.000', 'ok' , 'nok');

select decode(timestamp'01/01/2000', '01/01/2000 00:00:00', 'ok' , 'nok');

select decode(timestamp'01/01/2000', '01/01/2000', 'ok' , 'nok');

select decode(timestamp'01/01/2000', '00:00:00', 'ok' , 'nok');





-- date, other

select decode(date'01/01/2000', datetime'01/01/2000', 'ok' , 'nok');

select decode(date'01/01/2000', timestamp'01/01/2000', 'ok' , 'nok');

select decode(date'01/01/2000', date'01/01/2000', 'ok' , 'nok');

select decode(date'01/01/2000', time'00:00:00', 'ok' , 'nok');

select decode(date'01/01/2000', '01/01/2000 00:00:00.000', 'ok' , 'nok');

select decode(date'01/01/2000', '01/01/2000 00:00:00', 'ok' , 'nok');

select decode(date'01/01/2000', '01/01/2000', 'ok' , 'nok');

select decode(date'01/01/2000', '00:00:00', 'ok' , 'nok');



-- time, other

select decode(time'00:00:00', datetime'01/01/2000', 'ok' , 'nok');

select decode(time'00:00:00', timestamp'01/01/2000', 'ok' , 'nok');

select decode(time'00:00:00', date'01/01/2000', 'ok' , 'nok');

select decode(time'00:00:00', time'00:00:00', 'ok' , 'nok');

select decode(time'00:00:00', '01/01/2000 00:00:00.000', 'ok' , 'nok');

select decode(time'00:00:00', '01/01/2000 00:00:00', 'ok' , 'nok');

select decode(time'00:00:00', '01/01/2000', 'ok' , 'nok');

select decode(time'00:00:00', '00:00:00', 'ok' , 'nok');






-- string datetime, other

select decode('01/01/2000 00:00:00.000', datetime'01/01/2000', 'ok' , 'nok');

select decode('01/01/2000 00:00:00.000', timestamp'01/01/2000', 'ok' , 'nok');

select decode('01/01/2000 00:00:00.000', date'01/01/2000', 'ok' , 'nok');

select decode('01/01/2000 00:00:00.000', time'00:00:00', 'ok' , 'nok');

select decode('01/01/2000 00:00:00.000', '01/01/2000 00:00:00.000', 'ok' , 'nok');

select decode('01/01/2000 00:00:00.000', '01/01/2000 00:00:00', 'ok' , 'nok');

select decode('01/01/2000 00:00:00.000', '01/01/2000', 'ok' , 'nok');

select decode('01/01/2000 00:00:00.000', '00:00:00', 'ok' , 'nok');



-- string timestamp, other

select decode('01/01/2000 00:00:00', datetime'01/01/2000', 'ok' , 'nok');

select decode('01/01/2000 00:00:00', timestamp'01/01/2000', 'ok' , 'nok');

select decode('01/01/2000 00:00:00', date'01/01/2000', 'ok' , 'nok');

select decode('01/01/2000 00:00:00', time'00:00:00', 'ok' , 'nok');

select decode('01/01/2000 00:00:00', '01/01/2000 00:00:00.000', 'ok' , 'nok');

select decode('01/01/2000 00:00:00', '01/01/2000 00:00:00', 'ok' , 'nok');

select decode('01/01/2000 00:00:00', '01/01/2000', 'ok' , 'nok');

select decode('01/01/2000 00:00:00', '00:00:00', 'ok' , 'nok');


-- string date, other

select decode('01/01/2000', datetime'01/01/2000', 'ok' , 'nok');

select decode('01/01/2000', timestamp'01/01/2000', 'ok' , 'nok');

select decode('01/01/2000', date'01/01/2000', 'ok' , 'nok');

select decode('01/01/2000', time'00:00:00', 'ok' , 'nok');

select decode('01/01/2000', '01/01/2000 00:00:00.000', 'ok' , 'nok');

select decode('01/01/2000', '01/01/2000 00:00:00', 'ok' , 'nok');

select decode('01/01/2000', '01/01/2000', 'ok' , 'nok');

select decode('01/01/2000', '00:00:00', 'ok' , 'nok');




-- string time, other

select decode('00:00:00', datetime'01/01/2000', 'ok' , 'nok');

select decode('00:00:00', timestamp'01/01/2000', 'ok' , 'nok');

select decode('00:00:00', date'01/01/2000', 'ok' , 'nok');

select decode('00:00:00', time'00:00:00', 'ok' , 'nok');

select decode('00:00:00', '01/01/2000 00:00:00.000', 'ok' , 'nok');

select decode('00:00:00', '01/01/2000 00:00:00', 'ok' , 'nok');

select decode('00:00:00', '01/01/2000', 'ok' , 'nok');

select decode('00:00:00', '00:00:00', 'ok' , 'nok');



