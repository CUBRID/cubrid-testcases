--[er]create a vclass with condition 'int auto_increment not null'
create vclass vxoo ( id int auto_increment(1,2) ,
                   title varchar(100));
drop vclass vxoo;