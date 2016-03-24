--cases from dev


SELECT MAKETIME(12,15,30);

select maketime(0, 0, 0);

select maketime(24, 0, 0);

select maketime(0, 60, 0);

select maketime(0, 0, 60);

select maketime(-1, 0, 0);

select maketime(0, -1, 0);

select maketime(0, 0, -1);

select maketime(23, 59, 59);


-- test for valid input
select maketime(0,0,0), if (maketime(0,0,0) = '00:00:00', 'ok', 'nok');
select maketime(0,0,59), if (maketime(0,0,59) = '00:00:59', 'ok', 'nok');
select maketime(0,59,0), if (maketime(0,59,0) = '00:59:00', 'ok', 'nok');
select maketime(23,0,0), if (maketime(23,0,0) = '23:00:00', 'ok', 'nok');
select maketime(23,59,59), if (maketime(23,59,59) = '23:59:59', 'ok', 'nok');


-- check if ER_TIME_CONVERSION is occured.
select maketime(24, 0, 0);
select maketime(0, 60, 0);
select maketime(0, 0, 60);
select maketime(-1, 0, 0);
select maketime(0, -1, 0);
select maketime(0, 0, -1);

