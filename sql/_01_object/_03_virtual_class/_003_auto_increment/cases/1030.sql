--[er]create a vclass with condition 'smallint auto_increment not null'
create vclass vxoo ( id smallint auto_increment ,
                   title varchar(100));
drop vclass vxoo;