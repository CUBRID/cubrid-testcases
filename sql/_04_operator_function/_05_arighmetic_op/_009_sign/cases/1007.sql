--test sign function with integer type
create table test_number(
test_int int,		
test_smallint smallint,		
test_numeric numeric(38,10),		
test_float float,		
test_real real,		
test_double double, 		
test_monetary monetary);
------------------------------------------------------
insert into test_number values( 1,2,1940080.2381928563,763378.5813701674,638.688149415,1.0873497133088402E7,2048);
insert into test_number values( 2,3,2090402.277705913,9590589.85196592,164.17560682073,7523328.262894288,4096);
insert into test_number values( 3,4,3928299.552073598,1812221.489704989,348.3659053035,1.1289692469144318E7,6144);
insert into test_number values( 4,5,3882146.4736444056,9331204.100534454,881.993183851,966880.0841043274,8192);
insert into test_number values( 5,6,880214.146652177,2780612.406491831,953.472898811,8319367.031997498,10240);
insert into test_number values( 1,2,1.2381928563,7.5813701674,6.688149415,1.0873497133088402E7,2);
insert into test_number values( 2,3,2.277705913,9.85196592,1.17560682073,7.262894288,4);
insert into test_number values( 3,4,3.552073598,1.489704989,3.3659053035,1.1289692469144318E7,6);
insert into test_number values( 4,5,3.4736444056,9.100534454,8.993183851,9.0841043274,8);
insert into test_number values( 5,6,8.146652177,2.406491831,9.472898811,8.031997498,10);


insert into test_number values(0,0,0,0,0,0,0);
insert into test_number values(1,1,1,1,1,1,1);
insert into test_number values(null,null,null,null,null,null,null);

select sign(  test_int) from test_number order by 1;


drop table test_number;
