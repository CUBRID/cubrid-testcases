-- From QA Effort
select date_add('2000-01-01 00:00:00.0', INTERVAL 1 quarter);
select date_add('2000-01-01 00:00:00.0', INTERVAL -1 quarter);
select date_add('2000-01-01 00:00:00.0', INTERVAL 0 quarter);
select date_add('2000-01-01 00:00:00.0', INTERVAL 1.1 quarter);
select date_add('2000-01-01 00:00:00.0', INTERVAL 2*2/2 quarter);

select date_add('2000-03-11 00:00:00.0', INTERVAL 1 quarter);
select date_add('2000-03-11 00:00:00.0', INTERVAL -1 quarter);
select date_add('2000-03-11 00:00:00.0', INTERVAL 0 quarter);
select date_add('2000-03-11 00:00:00.0', INTERVAL 1.1 quarter);
select date_add('2000-03-11 00:00:00.0', INTERVAL 2*2/2 quarter);

-- From QA Effort remove "time".
select date_add('2000-01-01', INTERVAL 1 quarter);
select date_add('2000-01-01', INTERVAL -1 quarter);
select date_add('2000-01-01', INTERVAL 0 quarter);
select date_add('2000-01-01', INTERVAL 1.1 quarter);
select date_add('2000-01-01', INTERVAL 2*2/2 quarter);

select date_add('2000-03-11', INTERVAL 1 quarter);
select date_add('2000-03-11', INTERVAL -1 quarter);
select date_add('2000-03-11', INTERVAL 0 quarter);
select date_add('2000-03-11', INTERVAL 1.1 quarter);
select date_add('2000-03-11', INTERVAL 2*2/2 quarter);

-- From bug attachment.
SELECT DATE_ADD('1/31/2000', INTERVAL 1 QUARTER);
SELECT DATE_SUB('1/31/2000', INTERVAL 1 QUARTER);

