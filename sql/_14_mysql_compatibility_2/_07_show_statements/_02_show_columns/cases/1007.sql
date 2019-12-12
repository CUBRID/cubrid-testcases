-- SHOW COLUMNS -- check output against full expanded query
create table tt1 (i1 integer primary key,
		  i2 integer auto_increment,
		  i3 integer unique,
		  i4 integer default 33,
		  i5 integer not null
		  );
		  

show columns from tt1;

SELECT * FROM (SELECT A.attr_name AS Field,  CONCAT(type_name, IF (type_id=27 OR type_id=26 OR type_id=25 OR type_id=24 OR type_id=23 OR type_id=4 or type_id=22, CONCAT( '(', prec ,    IF(type_id=22,  CONCAT(',',scale,')') ,')')  ) , IF ( type_id=6 OR type_id = 7 OR type_id=8 , CONCAT(' OF ',Types_t.Composed_types),'') )) AS Type_,  IF(A.is_nullable=1  OR (SELECT 1 FROM tt1 WHERE false)=0,'YES','NO') AS Null_  , A.default_value AS Default_ , IF( (SELECT count(*)  FROM db_serial S WHERE S.att_name=A.attr_name AND S.class_name =  C.class_name ) >= 1 , 'auto_increment', '' ) AS Extra  FROM  _db_class  C , _db_domain D ,  _db_data_type T , _db_attribute A	LEFT JOIN (SELECT AA.attr_name ATTR,  GROUP_CONCAT( TT.type_name  ORDER BY 1 SEPARATOR ',') Composed_types FROM _db_attribute AA, _db_domain DD , _db_data_type TT  WHERE AA.class_of.class_name='tt1' AND DD.data_type=TT.type_id AND DD.object_of IN AA.domains GROUP BY AA.attr_name) Types_t    ON Types_t.ATTR=A.attr_name     WHERE  A.class_of=C  AND  A.data_type=T.type_id  AND  D.object_of=A AND C.class_name='tt1' ORDER BY A.def_order) show_columns ;

	  
drop table tt1;

