--Create index with keyword asc/desc on partition class
create class city (
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


INSERT INTO CITY VALUES (00001, 'Seoul', 'Kangnam-gu');
INSERT INTO CITY VALUES (00002, 'Pusan', 'Haewoondae-gu');
INSERT INTO CITY VALUES (00003, 'Ulan', 'Nam-gu');
INSERT INTO CITY VALUES (00004, 'Incheon', 'Bupyong-gu');
INSERT INTO CITY VALUES (00005, 'Daejon', 'Yousung-gu');
INSERT INTO CITY VALUES (00006, 'Kwangju', 'Kwangsan-gu');
INSERT INTO CITY VALUES (00007, 'Daegu', 'Dalseo-gu');
INSERT INTO CITY VALUES (00008, 'Kyunggi-do', 'Suwon');
INSERT INTO CITY VALUES (00009, 'Kangwon-do', 'Chunchon');
INSERT INTO CITY VALUES (00010, 'Chungbuk-do', 'Chungju');
INSERT INTO CITY VALUES (00011, 'Chungnam-do', 'Chonan');
INSERT INTO CITY VALUES (00012, 'Junbuk-do', 'Junjoo');
INSERT INTO CITY VALUES (00013, 'Junnam-do', 'Mokpo');
INSERT INTO CITY VALUES (00014, 'Kyungbuk-do', 'Andong');
INSERT INTO CITY VALUES (00015, 'Kyungnam-do', 'Changwon');
INSERT INTO CITY VALUES (00016, 'Jeju-do', 'Jeju');

create index idx_city_1 on city(city_id desc);
create index idx_city_2 on city(city_area asc);
create index idx_city_3 on city(city_name desc);
create index idx_city_4 on city(city_id desc, city_area asc);
create index idx_city_5 on city(city_id desc, city_name desc);
create index idx_city_6 on city(city_id asc, city_area desc, city_name desc);
create index idx_city_7 on city(city_id asc, city_area asc, city_name desc);
create index idx_city_8 on city(city_name desc, city_area asc, city_id desc);
select * from db_index where class_name='city' order by 1,2,3;
select * from db_index_key where class_name='city' order by 1,2,3;
select * from city where city_id < 00013 order by 1,2,3;
update city set city_id = 200001;
delete from city;


drop class city;



