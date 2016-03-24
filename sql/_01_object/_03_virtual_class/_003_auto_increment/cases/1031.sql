--[er]create a vclass with condition 'char auto_increment not null'
create vclass vxoo ( id char(10) auto_increment ,
                   title varchar(100));
drop vclass vxoo;