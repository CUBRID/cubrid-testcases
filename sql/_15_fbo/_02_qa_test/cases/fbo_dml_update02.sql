
-- constraints, foreign key not on blob/clob column.
create class update2_album (id char(10) primary key, title varchar(100), artist clob, bfile blob);
create class update2_track (albumn char(10), dsk INTEGER, posn INTEGER, song clob,fb blob, foreign key (albumn) references update2_album(id));

insert into update2_album values ('001','aaaa', char_to_clob('aaaa'), bit_to_blob(B'101') );
insert into update2_album values ('002','bbbb', char_to_clob('bbbb'), bit_to_blob(B'101') );
insert into update2_album values ('003','cccc', char_to_clob('cccc'), bit_to_blob(B'101') );
insert into update2_album values ('004','dddd', char_to_clob('dddd'), bit_to_blob(B'101') );
insert into update2_album values ('005','eeee', char_to_clob('eeee'), bit_to_blob(B'101') );

insert into update2_track values ( '001' , 1,1,char_to_clob('1212'), bit_to_blob(X'1011') );
insert into update2_track values ( '001' , 2,2,char_to_clob('2323'), bit_to_blob(X'1011') );
insert into update2_track values ( '002' , 3,3,char_to_clob('3434'), bit_to_blob(X'1011') );
insert into update2_track values ( '002' , 4,4,char_to_clob('4545'), bit_to_blob(X'1011') );
insert into update2_track values ( '003' , 5,5,char_to_clob('5656'), bit_to_blob(X'1011') );
insert into update2_track values ( '003' , 6,6,char_to_clob('6767'), bit_to_blob(X'1011') );

update update2_album set id= '006' where id= '001';
update update2_album set id= '006' where id= '005';

select id,title,clob_to_char(artist),blob_to_bit(bfile) from update2_album order by id;
select albumn,dsk,posn,clob_to_char(song),blob_to_bit(fb) from update2_track order by 1,2;

delete from update2_track;
delete from update2_album;
drop class update2_track;
drop class update2_album;