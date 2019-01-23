drop if exists p1,p7,p2;
create table p7 (a int primary key, b int,cte_VIF5zDGc9 timestamp on update current_timestamp);

create table p1 (b int , a int,FOREIGN KEY (a) REFERENCES p7(a),cte_tRxkzigQB timestamp on update current_timestamp);

create TABLE p2 UNDER p1 (c int ,cte_sGN7RSIBz timestamp on update current_timestamp);

select attr_name, is_nullable from db_attribute where class_name = 'p2'
order by 1,2;

select * from db_index where class_name = 'p2' order by 1,2;

select * from p2 order by 1,2;

drop p2;

drop table p1;

drop table p7;

drop if exists xoo;
--Create class with not null attribute and retrieve info from db_attribute

create class xoo ( id int not null, name string ,cte_M49Ny5GHW timestamp on update current_timestamp);

select * from db_attribute where class_name = 'xoo' order by 1;

drop xoo;


create class xoo ( id int auto_increment , title varchar(100),cte_FklWcrEYJ timestamp on update current_timestamp);

insert into xoo(title) values ('aaa');

insert into xoo(title) values ('bbb');

insert into xoo(title) values ('ccc');

select * from xoo order by 1;

update xoo set title = 'ddd' where title = 'ccc';
set @a=(current_timestamp);
select if(@a-cte_FklWcrEYJ >=0 and @a-cte_FklWcrEYJ<10,'ok','nok') from xoo where title = 'ddd';

select * from db_attribute where class_name = 'xoo' order by 1;

drop class xoo;


