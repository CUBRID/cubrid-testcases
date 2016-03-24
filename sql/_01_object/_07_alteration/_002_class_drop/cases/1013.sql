-- [er] drop a wrong type vclass

CREATE vCLASS ddl_0001 (a1 int,a2 int);

drop class ddl_0001;

drop vclass ddl_0001;
