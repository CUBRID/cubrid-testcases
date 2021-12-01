CREATE OR REPLACE FUNCTION sp() RETURN string as language java name 'SpTest8.SP() return java.lang.String';
CREATE OR REPLACE FUNCTION sp2() RETURN string as language java name 'SpTest8.SP2() return java.lang.String';
call sp();
call sp2();
drop FUNCTION sp;
drop FUNCTION sp2;
