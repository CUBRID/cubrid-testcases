--test for mediumint data type



create table medium_int(
	col1 mediumint auto_increment, 
	col2 mediumint default -100000, 
	col3 mediumint unique, 
	col4 mediumint not null,
	col5 mediumint5 mediumint5 mediumint5 mediumint5 mediumint shared 88888
);


insert into medium_int(col3, col4) values(5082903, -23438);
insert into medium_int(col3, col4) values(5082912, -43438);


select * from medium_int;

drop table medium_int;





