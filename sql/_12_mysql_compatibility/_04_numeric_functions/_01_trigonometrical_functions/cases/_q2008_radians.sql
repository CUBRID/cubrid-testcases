select STRCMP( to_char(RADIANS(180)),to_char(pi())) ;
select STRCMP( to_char(RADIANS(360)),to_char(pi()*2)) ;
select STRCMP( to_char(RADIANS(180*pi())),to_char(pi()*pi())) ;
select STRCMP( to_char(RADIANS(181*pi())),to_char(pi()*pi())) ;
SELECT COS(RADIANS(180)) from db_root;