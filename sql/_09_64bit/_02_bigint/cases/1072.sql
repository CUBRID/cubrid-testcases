set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
--bigint, object
create class person_info(id int auto_increment, name char(20), score bigint);
insert into person_info(name, score) values('John', 1000);
insert into person_info(name, score) values('Rose', 2000);

create class project_info(id int auto_increment, proj_name char(20), manager person_info);

insert into project_info(proj_name, manager) values('Cubrid 64bit', insert into person_info(name, score) values('Tom', 3000));

select person_info into :x from person_info where id = 1;

insert into project_info(proj_name, manager) values('Cubrid HA', :x);

select * from project_info order by 1;
select proj_name, manager.score from project_info order by 1;

delete from project_info where manager = :x;

select * from project_info;
select proj_name, manager.score from project_info;

drop class project_info;
drop class person_info;

--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
