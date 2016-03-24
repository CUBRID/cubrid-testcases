-- [er]retrieve by "like" keyword using escape with null

create class func_06 ( a string, b char(50) , c varchar(10));
insert into func_06 values (null,null,null);
insert into func_06 values ('abcdef ??? ABCDEF 大韓民國',null,null);
insert into func_06 values ('abcdef ??? ABCDEF 大韓民國','abc','123');
insert into func_06 values ('abcdef ??? ABCDEF 大韓民國','abc','');
insert into func_06 values ('abcdef ??? ABCDEF 大韓民國','abc','1');
insert into func_06 values ('abcdef ??? ABCDEF 大韓民國','???','123');
insert into func_06 values ('abcdef ??? ABCDEF 大韓民國','???','12345678');
insert into func_06 values ('abcdef ??? ABCDEF 大韓民國',' ???','12345678');
insert into func_06 values ('abcdef ??? ABCDEF 大韓民國','大韓民國','12345678');
insert into func_06 values ('abcdef ??? ABCDEF 大韓民國','','1');
insert into func_06 values ('abcdef ??? ABCDEF 大韓民國',' ',' ');
insert into func_06 values ('___________','%%%','%_%');


select a from func_06 where a like '\_%' escape null   order by 1;

drop class func_06;