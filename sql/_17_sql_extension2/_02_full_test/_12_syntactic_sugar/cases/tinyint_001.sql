--test for tinyint data type



create table tiny_int(
	col1 tinyint auto_increment, 
	col2 tinyint default -100, 
	col3 tinyint unique, 
	col4 tinyint not null,
	col5 tinyint shared 88
);


insert into tiny_int(col3, col4) values(50, -38);
insert into tiny_int(col3, col4) values(30, -78);


select * from tiny_int order by 1;

drop table tiny_int;





