--Create index on hash partition class and retrieve information from db_index_key
create class test_class (
    line_id   varchar(10)  not null ,
    station_id    integer,
    station_name  varchar(30),
    unique(line_id,station_id)
)
partition by hash (station_id)
partitions 4;

insert into test_class values ('Line 1', 1021, 'Dongdaemoon');
insert into test_class values ('Line 2', 2001, 'Kangnam');
insert into test_class values ('Line 3', 3003, 'Education Univ.');
insert into test_class values ('Line 4', 4005, 'Kumjung');
insert into test_class values ('Line 5', 5001, 'Kangdong');

select index_name, class_name, key_attr_name, key_order
from   db_index_key
where class_name = 'test_class'
order by index_name, key_order;

drop class test_class;
