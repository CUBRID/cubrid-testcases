--pass marginal and exceptional values to the parameter



--marginal values
--0001-01-01
select from_days(366);

--9999-12-31
select from_days(3652424);

--10000-03-15
select from_days(3652499);

--number between 3652424 and 2652499
select from_days(2652466);



--exceptional values
--number smaller than 366, returns 0000-00-00 in mysql
select from_days(35);

--number greater than 3652499, returns 0000-00-00 in mysql
select from_days(3652500);

select from_days(0);

select from_days(00.000);

select from_days(-1);

select from_days(10000000000);

select from_days(24*60*60);

select from_days(1.23);

select from_days(-2147483648);

select from_days();

select from_days(null);

select from_days(480, 200);

select from_days(?);

