--test update statistics on one partition of partition list class
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
 
update statistics on test_list__p__area1;
update statistics on test_list__p__area2;
update statistics on test_list__p__area3;
update statistics on test_list__p__area4;
update statistics on test_list__p__area5;

drop class test_list;
