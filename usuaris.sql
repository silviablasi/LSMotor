-- analytic user: Perform all kind of selects, view creations and view visualisation over OLAP database.
CREATE USER analytic_user;
GRANT SELECT, CREATE VIEW, SHOW VIEW	
ON	localolap.*		
TO analytic_user;


-- manager user: Responsible for keeping both databases up to date.
CREATE USER manager_user;
GRANT UPDATE, INSERT, DELETE, SELECT
ON *.*
TO manager_user;


-- rrhh user: Creates new users.
CREATE USER rrhh_user;
GRANT CREATE USER
ON *.*
TO rrhh_user;


-- VEURE ELS USUARIS CREATS
SELECT	* FROM mysql.user;





