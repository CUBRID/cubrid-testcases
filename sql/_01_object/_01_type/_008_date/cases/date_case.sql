

-- datetime, other

select case 
  when datetime'01/01/2000' = datetime'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when datetime'01/01/2000' = timestamp'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when datetime'01/01/2000' = date'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when datetime'01/01/2000' = time'00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when datetime'01/01/2000' = '01/01/2000 00:00:00.000' then 'ok' 
  else 'nok' 
end;

select case 
  when datetime'01/01/2000' = '01/01/2000 00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when datetime'01/01/2000' = '01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when datetime'01/01/2000' = '00:00:00' then 'ok' 
  else 'nok' 
end;






-- timestamp, other

select case 
  when timestamp'01/01/2000' = datetime'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when timestamp'01/01/2000' = timestamp'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when timestamp'01/01/2000' = date'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when timestamp'01/01/2000' = time'00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when timestamp'01/01/2000' = '01/01/2000 00:00:00.000' then 'ok' 
  else 'nok' 
end;

select case 
  when timestamp'01/01/2000' = '01/01/2000 00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when timestamp'01/01/2000' = '01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when timestamp'01/01/2000' = '00:00:00' then 'ok' 
  else 'nok' 
end;





-- date, other

select case 
  when date'01/01/2000' = datetime'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when date'01/01/2000' = timestamp'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when date'01/01/2000' = date'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when date'01/01/2000' = time'00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when date'01/01/2000' = '01/01/2000 00:00:00.000' then 'ok' 
  else 'nok' 
end;

select case 
  when date'01/01/2000' = '01/01/2000 00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when date'01/01/2000' = '01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when date'01/01/2000' = '00:00:00' then 'ok' 
  else 'nok' 
end;



-- time, other

select case 
  when time'00:00:00' = datetime'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when time'00:00:00' = timestamp'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when time'00:00:00' = date'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when time'00:00:00' = time'00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when time'00:00:00' = '01/01/2000 00:00:00.000' then 'ok' 
  else 'nok' 
end;

select case 
  when time'00:00:00' = '01/01/2000 00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when time'00:00:00' = '01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when time'00:00:00' = '00:00:00' then 'ok' 
  else 'nok' 
end;






-- string datetime, other

select case 
  when '01/01/2000 00:00:00.000' = datetime'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00.000' = timestamp'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00.000' = date'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00.000' = time'00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00.000' = '01/01/2000 00:00:00.000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00.000' = '01/01/2000 00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00.000' = '01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00.000' = '00:00:00' then 'ok' 
  else 'nok' 
end;



-- string timestamp, other

select case 
  when '01/01/2000 00:00:00' = datetime'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00' = timestamp'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00' = date'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00' = time'00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00' = '01/01/2000 00:00:00.000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00' = '01/01/2000 00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00' = '01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000 00:00:00' = '00:00:00' then 'ok' 
  else 'nok' 
end;


-- string date, other

select case 
  when '01/01/2000' = datetime'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000' = timestamp'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000' = date'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000' = time'00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000' = '01/01/2000 00:00:00.000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000' = '01/01/2000 00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000' = '01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '01/01/2000' = '00:00:00' then 'ok' 
  else 'nok' 
end;




-- string time, other

select case 
  when '00:00:00' = datetime'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '00:00:00' = timestamp'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '00:00:00' = date'01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '00:00:00' = time'00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when '00:00:00' = '01/01/2000 00:00:00.000' then 'ok' 
  else 'nok' 
end;

select case 
  when '00:00:00' = '01/01/2000 00:00:00' then 'ok' 
  else 'nok' 
end;

select case 
  when '00:00:00' = '01/01/2000' then 'ok' 
  else 'nok' 
end;

select case 
  when '00:00:00' = '00:00:00' then 'ok' 
  else 'nok' 
end;



