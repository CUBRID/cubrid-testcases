--create list partiition table with a function to_char to change smallint  data type to char data type as a partition value

create table list_test(id int,
			test_int int,                                
			test_smallint smallint, primary key(id,test_smallint))                      
		PARTITION BY LIST (to_char(test_smallint)) (       
		PARTITION p0 VALUES IN ('1','2','3','4','5' ),              
		PARTITION p1 VALUES IN ('6','7','8','9','10'),              
		PARTITION p2 VALUES IN ('11','12','13','14' ),              
		PARTITION p3 VALUES IN ('15','16','17','18' ),              
		PARTITION p4 VALUES IN ('19','20',null)
	);        
insert into list_test values( 1,1,1);
insert into list_test values( 2,2,2);
insert into list_test values( 3,3,3);
insert into list_test values( 4,4,4);
insert into list_test values( 5,5,5);
insert into list_test values( 6,6,6);
insert into list_test values( 7,7,7);	
insert into list_test values( 8,8,8);
insert into list_test values( 9,9,9);
insert into list_test values(10,10,10);
insert into list_test values(11,11,11);
insert into list_test values(12,12,12);
insert into list_test values(13,13,13);
insert into list_test values(14,14,14);
insert into list_test values(15,15,15);
insert into list_test values(16,16,16);
insert into list_test values(17,17,17);
insert into list_test values(18,18,18);
insert into list_test values(19,19,19);
insert into list_test values(20,20,20);
insert into list_test values(21,NULL,NULL);
select * from list_test__p__p0 order by id;
select * from list_test__p__p1 order by id;
select * from list_test__p__p2 order by id;
select * from list_test__p__p3 order by id;
select * from list_test__p__p4 order by id;


drop class list_test;
