--Test key word only with one of partition in list partition class

create class test_list(
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
 
update statistics on only test_list__p__area1;


drop class test_list;
