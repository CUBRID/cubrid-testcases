--[er]create a vclass with condition 'date auto_increment not null'
create vclass vxoo ( id date auto_increment ,
                   title varchar(100));
drop vclass vxoo;