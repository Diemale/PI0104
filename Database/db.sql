DROP DATABASE if exists pi01;
CREATE DATABASE IF NOT EXISTS pi01;
USE pi01;

/*Catalogo de funciones y procedimientos*/
SET GLOBAL log_bin_trust_function_creators = 1;
DROP FUNCTION IF EXISTS `UC_Words`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `UC_Words`( str VARCHAR(255) ) RETURNS varchar(255) CHARSET utf8
BEGIN  
  DECLARE c CHAR(1);  
  DECLARE s VARCHAR(255);  
  DECLARE i INT DEFAULT 1;  
  DECLARE bool INT DEFAULT 1;  
  DECLARE punct CHAR(17) DEFAULT ' ()[]{},.-_!@;:?/';  
  SET s = LCASE( str );  
  WHILE i < LENGTH( str ) DO  
 
 BEGIN  
       SET c = SUBSTRING( s, i, 1 );  
       IF LOCATE( c, punct ) > 0 THEN  
        SET bool = 1;  
      ELSEIF bool=1 THEN  
        BEGIN  
          IF c >= 'a' AND c <= 'z' THEN  
             BEGIN  
               SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1));  
               SET bool = 0;  
             END;  
           ELSEIF c >= '0' AND c <= '9' THEN  
            SET bool = 0;  
          END IF;  
        END;  
      END IF;  
      SET i = i+1;  
    END;  
  END WHILE;  
  RETURN s;  
END$$
DELIMITER ;
DROP PROCEDURE IF EXISTS `Llenar_dimension_calendario`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Llenar_dimension_calendario`(IN `startdate` DATE, IN `stopdate` DATE)
BEGIN
    DECLARE currentdate DATE;
    SET currentdate = startdate;
    WHILE currentdate < stopdate DO
        INSERT INTO calendario VALUES (
                        YEAR(currentdate)*10000+MONTH(currentdate)*100 + DAY(currentdate),
                        currentdate,
                        YEAR(currentdate),
                        MONTH(currentdate),
                        DAY(currentdate),
                        QUARTER(currentdate),
                        WEEKOFYEAR(currentdate),
                        DATE_FORMAT(currentdate,'%W'),
                        DATE_FORMAT(currentdate,'%M'));
        SET currentdate = ADDDATE(currentdate,INTERVAL 1 DAY);
    END WHILE;
END$$
DELIMITER ;


/*Importacion de la tablas iniciales*/
DROP TABLE IF EXISTS `precios_semana_20200413`;
CREATE TABLE IF NOT EXISTS `precios_semana_20200413` (
  	`precioOld` 	varchar(20),
  	`IdProducto` 	varchar(20),
  	`IdSucursal` 	varchar(15)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PI01\\precios_semana_20200413.csv' 
INTO TABLE `precios_semana_20200413` 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;



DROP TABLE IF EXISTS `producto`;
CREATE TABLE IF NOT EXISTS `producto` (
  	`IdProducto` 	varchar(20),
  	`nombre` 		varchar(40),
  	`presentacion` 	varchar(150),
    `categoria1`	varchar(50),
    `categoria2`  varchar(50),
    `categoria3`	varchar(50),
    `adicional`		varchar(30)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PI01\\producto.csv' 
INTO TABLE `producto` 
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;



DROP TABLE IF EXISTS `sucursal`;
CREATE TABLE IF NOT EXISTS `sucursal` (
  	`IdSucursal` 	varchar(20),
  	`IdComercio` 	INTEGER,
  	`IdBandera` 	varchar(150),
    `banderaDescripcion`	varchar(100),
    `comercioRazonSocial`  varchar(150),
    `provincia`				varchar(35),
    `localidad`				varchar(70),
    `direccion`				varchar(70),
    `lat`				varchar(70),
    `lng`				decimal(13,10),
    `sucursalNombre`	varchar(70),
    `sucursalTipo`		varchar(70)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PI01\\sucursal.csv' 
INTO TABLE `sucursal`  
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

select * from sucursal;










