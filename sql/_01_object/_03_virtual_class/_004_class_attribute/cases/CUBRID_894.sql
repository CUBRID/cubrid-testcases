-- change vclass's attribute

create class inventory (attr char(10));
alter class inventory add attribute new_attr string;
create vclass inventory_v as select * from inventory;

alter vclass inventory_v modify attribute new_attr string default '10'; 

drop vclass inventory_v;
drop class inventory;

