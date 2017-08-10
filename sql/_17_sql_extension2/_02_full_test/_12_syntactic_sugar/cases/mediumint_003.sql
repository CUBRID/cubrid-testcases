--insert marginal and out-of-range values into a mediumint column


create table medium_int(col1 mediumint);

--minimum value for mediumint in mysql
insert into medium_int values(-8388608);
--maximum values for mediumint in mysql
insert into medium_int values(8388607);
--insert data which is smaller than the minimum value in mysql
insert into medium_int values(-30000000);
--insert data which is greater than the maximum value in mysql
insert into medium_int values(45648293);
--minimum value for int in cubrid 
insert into medium_int values(-2147483648);
--maximum value for int in cubrid
insert into medium_int values(2147483647);
--insert data which is smaller than the minimum value in mysql
insert into medium_int values(-58990839202);
--insert data which is greater than the maximum value in mysql
insert into medium_int values(4739272840239480293);
--insert float date
insert into medium_int values(25342.65564);


select * from medium_int order by 1;

drop table medium_int;





