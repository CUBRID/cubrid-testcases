--[er]create a vclass with condition 'string auto_increment not null'
create vclass vxoo ( id string auto_increment ,
                   title varchar(100));
drop vclass vxoo;