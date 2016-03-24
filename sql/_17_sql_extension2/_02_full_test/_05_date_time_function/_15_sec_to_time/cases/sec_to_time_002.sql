--pass marginal int values to the parameter


--marginal values
select sec_to_time(2147483648);

select sec_to_time(23*59*59);

select sec_to_time(0);

select sec_to_time(1);




--exceptional values
select sec_to_time(-1);

select sec_to_time(10000000000);

select sec_to_time(24*60*60);

select sec_to_time(1.23);

select sec_to_time(-2147483648);

select sec_to_time();

select sec_to_time(null);

select sec_to_time(200, 200);

select sec_to_time(?);

select sec_to_time;

