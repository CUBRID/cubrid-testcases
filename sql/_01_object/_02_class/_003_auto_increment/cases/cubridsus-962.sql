--To test if you create a class with an auto_increment attribute, when you drop the attribute,whether you will get a error "DELETE authorization failure"

create class xoo ( id int auto_increment );
alter class xoo drop attribute id;

drop class xoo;