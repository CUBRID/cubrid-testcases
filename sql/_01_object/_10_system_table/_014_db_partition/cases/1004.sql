--Create list partition and retrieve information from db_partition
create class test_class (
city_id    integer,
city_area    varchar(20),
city_name    varchar(20)
)
partition by list (city_area) (
     partition area1 values in ('Seoul', 'Incheon', 'Kyunggi-do'),
     partition area2 values in ('Daejon', 'Chungnam-do', 'Chungbuk-do'),
     partition area3 values in ('Kwangju', 'Junnam-do', 'Junbuk-do'),
     partition area4 values in ('Daegu', 'Pusan', 'Ulan','Kyungnam-do', 'Kyungbuk-do'),
     partition area5 values in ('Kangwon-do', 'Jeju-do')
 );



select * from db_partition
where class_name = 'test_class' order by 1,2,3;

drop class test_class;