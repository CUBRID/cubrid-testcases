--[er] create class and vclass,add super vclass for the created class

CREATE CLASS ddl_0001;
CREATE VCLASS ddl_0002;

ALTER CLASS ddl_0001 add superclass ddl_0002;




drop vclass ddl_0002;
drop class ddl_0001;