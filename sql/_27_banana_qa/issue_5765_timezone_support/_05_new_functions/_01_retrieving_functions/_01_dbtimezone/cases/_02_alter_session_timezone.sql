--alter session timezone, the dbtimezone result should not be changed.

set timezone '-2:00';
select dbtimezone();

set timezone '+7:00';
select dbtimezone();

set timezone 'Asia/Bahrain';
select dbtimezone();

set timezone 'Europe/Luxembourg';
select dbtimezone();

set timezone 'America/Argentina/San_Luis';
select dbtimezone();


set timezone 'Asia/Seoul';
