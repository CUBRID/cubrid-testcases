CREATE FUNCTION sp() RETURN string as language java name 'SpTest8.SP() return java.lang.String';

call sp();

drop FUNCTION sp;
