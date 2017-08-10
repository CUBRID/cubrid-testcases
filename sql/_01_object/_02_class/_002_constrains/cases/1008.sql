--[er]test unique of constraint using shared keyword

create class test_class(
a integer ,
b integer shared 888,
unique(b));

drop class test_class;