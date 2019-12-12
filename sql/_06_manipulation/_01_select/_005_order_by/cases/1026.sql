--Test order by with hash partition class
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

select line_id, station_id, station_name from substation 
order by line_id, station_id;

select line_id, station_id, station_name from substation 
order by 1,3;


drop class substation;