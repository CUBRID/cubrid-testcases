--insert marginal and out-of-range values into a tinyint column


create table tiny_int(col1 tinyint);

--minimum value for tinyint in mysql
insert into tiny_int values(-128);
--maximum values for tinyint in mysql
insert into tiny_int values(127);
--insert data which is smaller than the minimum value in mysql
insert into tiny_int values(-3000);
--insert data which is greater than the maximum value in mysql
insert into tiny_int values(456);
--minimum value for smallint in cubrid 
insert into tiny_int values(-32768);
--maximum value for smallint in cubrid
insert into tiny_int values(32767);
--insert data which is smaller than the minimum value in mysql
insert into tiny_int values(-58990);
--insert data which is greater than the maximum value in mysql
insert into tiny_int values(4739272);
--insert float date
insert into tiny_int values(25.65564);


select * from tiny_int order by 1;

drop table tiny_int;





