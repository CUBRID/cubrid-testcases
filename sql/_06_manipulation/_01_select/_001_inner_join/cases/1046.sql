--Test inner join query

create table authors (au_id char(10), name char(10)); 
create unique index uidx_authors on authors(au_id);

select * from db_index a 
inner join db_index_key b 
on a.class_name = b.class_name 
and a.index_name = b.index_name 
where a.class_name = 'authors' ;

select * from db_index a, db_index_key b 
where a.class_name = b.class_name and a.index_name = b.index_name 
and a.class_name = 'authors' ;

create table xx (a varchar(255), b char(5), c varchar(255)) ;
create class yy (a varchar(255), c varchar(255)) ;

insert into xx values( 'aa' ,'1','aaaa'); 
insert into xx values( 'bb' ,'1','bbbb'); 
insert into xx values( 'cc' ,'1','cccc'); 
insert into xx values( 'dd' ,'1','dddd'); 
insert into xx values( 'ee' ,'1','eeee'); 
insert into xx values( 'ff' ,'1','ffff'); 

insert into yy values( 'aa','aaaa'); 
insert into yy values( 'bb','bbbb'); 
insert into yy values( 'cc','cccc'); 
insert into yy values( 'dd','dddd'); 
insert into yy values( 'ee','eeee'); 
insert into yy values( 'ff','ffff'); 

select * from xx a 
inner join yy b 
on a.c = b.c 
and a.a = b.a 
where a.c = 'ffff' ;

drop class authors;
drop class xx,yy;
