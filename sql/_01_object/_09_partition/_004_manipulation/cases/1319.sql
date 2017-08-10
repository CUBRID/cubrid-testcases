-- [er]insert data which create class using list partition on int field having default value

create class list_test (store_id int default 1, b int)
partition by list (store_id) (
PARTITION pNorth VALUES IN (3, 5, 6, 9, 17), 
PARTITION pWest VALUES IN (4, 12, 13, 14, 18), 
PARTITION pCentral VALUES IN (7, 8, 15, 16) 
);
                                  
insert into list_test(b) values (1);
insert into list_test values(2,2);


drop table list_test;
