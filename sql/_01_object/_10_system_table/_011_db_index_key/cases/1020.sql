--Create index on list partition and retrieve information from db_index_key
create class test_class (
city_id    integer,
city_area    varchar(20),
city_name    varchar(20),
primary key(city_id,city_area)
)
partition by list (city_area) (
     partition area1 values in ('Seoul', 'Incheon', 'Kyunggi-do'),
     partition area2 values in ('Daejon', 'Chungnam-do', 'Chungbuk-do'),
     partition area3 values in ('Kwangju', 'Junnam-do', 'Junbuk-do'),
     partition area4 values in ('Daegu', 'Pusan', 'Ulan','Kyungnam-do', 'Kyungbuk-do'),
     partition area5 values in ('Kangwon-do', 'Jeju-do')
 );


select index_name, class_name, key_attr_name, key_order
from   db_index_key
where  class_name = 'test_class'
order by index_name, key_order;

drop class test_class;
