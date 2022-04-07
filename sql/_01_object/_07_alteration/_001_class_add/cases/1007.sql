-- [er]create vclass then use change_owner function to change authority,then report error because the function only be performed by the DBA or a DBA group member.

CREATE VCLASS ddl_0001;

call change_owner('ddl_0001', 'PUBLIC') on class db_authorizations;

ALTER VCLASS public.ddl_0001 ADD ATTRIBUTE
       korean_name character varying(30),
       curr_cost character varying(20),
       buy_cost character varying(20);

ALTER VCLASS public.ddl_0001
	ADD QUERY select col1, col2, col3 from ddl_1010;




drop view public.ddl_0001;
