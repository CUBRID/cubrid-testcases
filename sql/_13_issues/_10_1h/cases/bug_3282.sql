select case when date('  2000-01-01  ') = date('2000-01-01') then 'OK' else 'NOK' end;
select case when date('2000-01-01  ') = date('2000-01-01') then 'OK' else 'NOK' end;
select case when date('  2000-01-01') = date('2000-01-01') then 'OK' else 'NOK' end;

select case when datediff('  2000-01-08  ', '  2000-01-01  ') = datediff('2000-01-08','2000-01-01') then 'OK' else 'NOK' end;
select case when datediff('2000-01-08  ', '2000-01-01  ') = datediff('2000-01-08','2000-01-01') then 'OK' else 'NOK' end;
select case when datediff('  2000-01-08', '  2000-01-01') = datediff('2000-01-08','2000-01-01') then 'OK' else 'NOK' end;

select case when timestamp('  2000-01-01  ') = timestamp('2000-01-01') then 'OK' else 'NOK' end;
select case when timestamp('2000-01-01  ') = timestamp('2000-01-01') then 'OK' else 'NOK' end;
select case when timestamp('  2000-01-01') = timestamp('2000-01-01') then 'OK' else 'NOK' end;

select case when timestamp('  2000-01-01  07:30:30  ') = timestamp('2000-01-01 07:30:30') then 'OK' else 'NOK' end;
select case when timestamp('2000-01-01  07:30:30  ') = timestamp('2000-01-01 07:30:30') then 'OK' else 'NOK' end;
select case when timestamp('  2000-01-01  07:30:30') = timestamp('2000-01-01 07:30:30') then 'OK' else 'NOK' end;
