--Create index with keyword asc/desc on partition class
create class substation (
    line_id   varchar(10)  not null,
    station_id    integer,
    station_name  varchar(30)
)
partition by hash (station_id)
partitions 4
;

insert into substation values ('Line 1', 1021, 'Dongdaemoon');
insert into substation values ('Line 1', 1031, 'Byoungjum');
insert into substation values ('Line 2', 2001, 'Kangnam');
insert into substation values ('Line 2', 2002, 'Kangbyun');
insert into substation values ('Line 2', 2003, 'Kunkook Univ.');
insert into substation values ('Line 3', 3002, 'Bus_terminal');
insert into substation values ('Line 3', 3003, 'Education Univ.');
insert into substation values ('Line 4', 4004, 'Guachon');
insert into substation values ('Line 4', 4005, 'Kumjung');
insert into substation values ('Line 5', 5001, 'Kangdong');
insert into substation values ('Line 5', 5009, 'Gunja');
insert into substation values ('Line 6', 6002, 'Gongduk');
insert into substation values ('Line 6', 6009, 'Dongmyo');
insert into substation values ('Line 7', 7001, 'Gasan_Digital');
insert into substation values ('Line 7', 7003, 'Kunkook Univ.');
insert into substation values ('Line 8', 8001, 'Garak_market');
insert into substation values ('Line 8', 9005, 'KangdongOffice');

create index idx_substation_1 on substation(line_id desc);
create index idx_substation_2 on substation(station_id asc);
create index idx_substation_3 on substation(station_name desc);
create index idx_substation_4 on substation(line_id asc, station_id desc);
create index idx_substation_5 on substation(line_id desc, station_id asc, station_name desc);
create index idx_substation_6 on substation(station_name asc, line_id desc);
select * from db_index where class_name='substation' order by 1,2,3;
select * from db_index_key where class_name='substation' order by index_name,class_name,key_attr_name;
select * from substation where line_id < 'Line 5' order by 1,2,3;
update substation set line_id='Line9' where line_id = 'Line 1';
delete from substation;
 

drop class substation;
