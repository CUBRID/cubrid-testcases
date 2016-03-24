autocommit off;
	create class mother ( myself mother );
        create class son as subclass of mother ( myself son );
rollback;
