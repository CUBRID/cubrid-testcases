create class update3_sh3 (name varchar(10), description string, photo bit varying, gender char(1) shared 'M');
insert into update3_sh3 values ('John', 'This is John' , B'10010', 'M' );
insert into update3_sh3 values ('Mike', 'This is Mike' , B'10011', 'W' );
update update3_sh3 set description='That is John' , photo = B'101000', gender='M' where name = 'John'; 
update update3_sh3 set gender='M' , description='That is John' , photo = B'101000'where name = 'Mike';
select * from update3_sh3 order by 1; 

drop table update3_sh3;
