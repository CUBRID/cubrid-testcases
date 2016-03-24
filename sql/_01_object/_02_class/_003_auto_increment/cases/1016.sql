--[er] create a table with an int auto_increment field,insert data to this table by no specifying the field.

create table xoo (id int auto_increment,
                        title varchar(100));

insert into xoo values('aaa');

drop class xoo;
