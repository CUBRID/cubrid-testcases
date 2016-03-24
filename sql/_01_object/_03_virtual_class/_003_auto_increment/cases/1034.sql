--[er]create a vclass with condition 'set auto_increment not null'
create vclass vxoo ( id set auto_increment ,
                   title varchar(100));
drop vclass vxoo;