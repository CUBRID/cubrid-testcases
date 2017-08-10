create table strtodate (str varchar(30));
insert into strtodate values ('09:30:17a');
select str_to_date(str, '%h:%i:%s') from strtodate;
drop table strtodate;