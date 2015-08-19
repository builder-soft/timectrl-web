/**
 * Tablas temporales
 * http://fbddocs.dlsi.ua.es/practicas-sql-espanol/vistas-y-tablas-temporales
 * 
* http://www.mysqltutorial.org/mysql-stored-procedure-tutorial.aspx
*
* Lanzar error desde MySQL
* https://blogs.oracle.com/svetasmirnova/entry/how_to_raise_error_in
* http://dev.mysql.com/doc/refman/5.5/en/signal.html
* http://illya-keeplearning.blogspot.com/2009/03/raise-exception-error-in-mysql-50.html
*
* Para hacer un "eval" en MySQL
* http://dev.mysql.com/doc/refman/5.1/en/sql-syntax-prepared-statements.html
*
* http://dev.mysql.com/doc/refman/5.5/en/connector-j-reference-type-conversions.html
* Los tipos de datos que vamos a usar...
* MYSQL					Java
* -----------------------------------------------
* BIT					java.lang.Boolean
* INTEGER [UNSIGNED]	java.lang.Integer, if UNSIGNED java.lang.Long
* BIGINT [UNSIGNED]		java.lang.Long, if UNSIGNED java.math.BigInteger
* DECIMAL(20,4)			java.math.BigDecimal
* DOUBLE				java.lang.Double
* DATE					java.sql.Date
* TIMESTAMP				java.sql.Timestamp
* VARCHAR				java.lang.String
* LONGTEXT				java.lang.String
*/

/* Tabla con el listado de usuarios del sistema, independiente del dominio al cual pertenece */
CREATE TABLE IF NOT EXISTS bsframework.tUser (
	cId			BIGINT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
	cMail 		VARCHAR(50) NOT NULL UNIQUE COMMENT 'Campo con el cual el usuario hace login, ideal es que sea el mail para que no se le olvide',
	cName		VARCHAR(100) NOT NULL COMMENT 'El nombre real del usuario',
	cPassword	VARCHAR(64) COMMENT 'Codificada en md5',
	cAdmin		BIT			NOT NULL DEFAULT 0	COMMENT 'Este campo indica si tiene accedo de administrador, de manera de poder modificar usuarios de todos los dominios'
) ENGINE=innoDB;

/* Tabla con el listado de dominios posibles, cabe señanar que por cada dominio que sea 
creado, debe existir una base de datos. El nombre de la base de datos, debe coincidir con 
el valor puesto en la columna cAlias de esta tabla.
*/
CREATE TABLE IF NOT EXISTS bsframework.tDomain (
	cId			BIGINT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
	cName		VARCHAR(100) NULL,
	cAlias		VARCHAR(15) NULL	
) ENGINE=innoDB;

/* En esta tabla, se guarda la relación para determinar a que dominios puede acceder un usuario */
CREATE TABLE IF NOT EXISTS bsframework.tR_UserDomain (
	cUser		BIGINT  NOT NULL,
	cDomain		BIGINT  NOT NULL	
) ENGINE=innoDB;

/* Aqui se guardan atributos adicionales para cada dominio, en un inicio, se guardan los datos 
de conección a la base de datos para cada uno de ellos*/
CREATE TABLE IF NOT EXISTS bsframework.tDomainAttribute (
	cId			BIGINT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
	cDomain		BIGINT  NOT NULL,
	cKey		VARCHAR(20) NULL,
	cName		VARCHAR(20) NULL,
	cValue		VARCHAR(50) NULL
) ENGINE=innoDB;

 /** V I S T A S **/
DROP VIEW IF EXISTS bsframework.vUserAdmin;
CREATE VIEW bsframework.vUserAdmin
AS
 		SELECT		cId, cMail, cName, cAdmin 
		FROM 		bsframework.tUser;


DROP VIEW IF EXISTS bsframework.vUser;
CREATE VIEW bsframework.vUser
AS
		SELECT		cId, cMail, cName 
		FROM 		bsframework.tUser
		WHERE		!cAdmin;
 
 
 