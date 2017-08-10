
--we expect below one is supported by CUBRID
select 1=1;
--Below is good.
select (1=1);

--we expect below one is supported by CUBRID
select 1>0;
--Below is good.
select (1>0);

select 1+1>0;
select (1+1>0);

select 1*1>0;
select (1/1>0);

select '1'>'0';
select ('1'>'0');

select '1+1'>'0';
select ('1-1'>'0');

select '1/1'>'0';
select ('1%1'>'0');


