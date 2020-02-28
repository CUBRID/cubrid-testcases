-- create table & idx
create table rvc_tmp(col1 int, col2 int, col3 int, col4 int, col5 int);
insert into rvc_tmp values(1,2,3,4,5),(1,1,1,1,1),(2,2,2,2,2),(3,3,3,3,3);
create index idx on rvc_tmp(col1,col2,col3,col4);
create index idx2 on rvc_tmp(nvl(col1,1),col2,col3,col4);

-- test start
select * from rvc_tmp where col1 in {2,3};
select * from rvc_tmp where col1 IN (1,2);
select * from rvc_tmp where (col1,col2) IN ((1,1),(2,2));
select * from rvc_tmp where (col1,col2) IN ((1,1));
select * from rvc_tmp where (col1,col2) NOT IN ((1,1),(2,2));
select * from rvc_tmp where (col1,col2) NOT IN ((1,1));
select * from rvc_tmp where (col1,col2) IN (select col1,col2 from rvc_tmp where col1 = 2);
select * from rvc_tmp where (col1,col2) NOT IN (select col1,col2 from rvc_tmp where col1 = 2);
select * from rvc_tmp where (col1,col2) = (1,1);
select * from rvc_tmp where (col1,col2) <> (1,1);
select * from rvc_tmp where (col1,col2) < (2,2);
select * from rvc_tmp where (col1,col2) <= (2,2);
select * from rvc_tmp where (col1,col2) > (2,2);
select * from rvc_tmp where (col1,col2) >= (2,2);
select * from rvc_tmp where (col1,col2) = (select col1,col2 from rvc_tmp where col1 = 3);
select * from rvc_tmp where (col1,col2) <> (select col1,col2 from rvc_tmp where col1 = 3);
select * from rvc_tmp where (col1,col2) < (select col1,col2 from rvc_tmp where col1 = 3);
select * from rvc_tmp where (col1,col2) <= (select col1,col2 from rvc_tmp where col1 = 3);
select * from rvc_tmp where (col1,col2) > (select col1,col2 from rvc_tmp where col1 = 3);
select * from rvc_tmp where (col1,col2) >= (select col1,col2 from rvc_tmp where col1 = 3);

-- ERROR: Query result contains more than a single tuple.
select * from rvc_tmp where (col1,col2) = (select col1,col2 from rvc_tmp where col1 = 1);
select * from rvc_tmp where (col1,col2) < (select col1,col2 from rvc_tmp where col2 = 2);


select * from rvc_tmp where (col4,col2,col1,col3) = (4,2,1,3);
select * from rvc_tmp where (col4,col2,col1,col3) in ((4,2,1,3),(1,1,1,1));

-- ERROR: The number of attributes(2) and select columns(3) are not equal.
select * from rvc_tmp where (col1,col2) = (1,2,3);
-- ERROR: The number of attributes(2) and select columns(0) are not equal.
select * from rvc_tmp where (col1,col2) in (1,2);
-- ERROR: The number of attributes(2) and select columns(3) are not equal.
select * from rvc_tmp where (col1,col2) in ((1,1),(1,2,3),(3,3));
-- ERROR: The number of attributes(2) and select columns(0) are not equal.
select * from rvc_tmp where (col1,col2) in ((1,1),((2,2),(3,3)),(4,4));
-- ERROR: The number of attributes(2) and select columns(0) are not equal.
select * from rvc_tmp where (col1,col2) IN ((1,1),2,(3,3));
-- ERROR: System error (index plan generation - invalid key value) in /root/cubrid/src/parser/xasl_generation.c (line: 11526)
select * from rvc_tmp where col1 IN ((1,1),(3,3));
-- ERROR: The number of attributes(3) and select columns(0) are not equal
select * from rvc_tmp where (col1,col2,col4) in (1,1,1);
-- ERRORThe number of attributes(2) and select columns(3) are not equal.
select * from rvc_tmp where (col1,col2) IN (select col1,col2,col3 from rvc_tmp where col1 = 2);

--test end
drop table rvc_tmp;
