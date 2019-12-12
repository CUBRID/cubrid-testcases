-- [er] create table with precision of zero for bit, char, .. and tests a create syntax with several data type like bit,bit varying,char,nchar but the size is zero and then report size error 
create class c_b (b bit(0)); 
create class c_vb (vb bit varying(0));
create class c_c (c char(0)); 
create class c_nc (nc nchar(0));

drop c_b;
drop c_vb;
drop c_c;
drop c_nc;