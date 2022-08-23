create database Hospital;
use Hospital;

if object_id ('hospitales') is not null
	drop table hospitales;

if object_id('sala') is not null
	drop table sala;

if object_id('enfermero') is not null
	drop table enfermero;

if object_id('paciente') is not null
	drop table paciente;

if object_id('ocupacion') is not null
	drop table ocupacion;


create table hospitales
(
	hospital_cod varchar(2) not null,
	nombre varchar(20) not null,
	direccion varchar(50),
	telefono varchar(9),
	num_cama varchar(3)
);
--creando restricciones
exec sp_columns hospitales;
exec sp_helpconstraint hospitales;
alter table hospitales add constraint PK_hospitales_codigo primary key (hospital_cod);
alter table hospitales add constraint DF_hopitales_telefono default '000-000-000-000' for telefono;

create table sala
(
	sala_cod varchar(2) not null,
	nombre varchar(50),
	num_cama varchar(3),
	hospital_cod varchar(2) not null
);

exec sp_columns sala;
exec sp_helpconstraint sala;
alter table sala add constraint PK_sala_codigo primary key(sala_cod);
alter table sala add constraint FK_hospital_cod foreign key (hospital_cod) references hospitales (hospital_cod);


create table enfermero
(
	dni varchar(8) not null,
	nombre varchar(50),
	apellido varchar(50),
	funcion varchar(70),
	turno char(1) not null,
	salario decimal(10),
	sala_cod varchar(2) not null,
	hospital_cod varchar(2) not null,
);
exec sp_columns enfermero;
exec sp_helpconstraint enfermero;
alter table enfermero add constraint PK_enfermero_dni primary key(dni);
alter table enfermero add constraint FK_enfermero_sala foreign key(sala_cod) references sala(sala_cod);
alter table enfermero add constraint FK_enfermero_hospital foreign key(hospital_cod) references hospitales(hospital_cod);
alter table enfermero add constraint CK_enfermero_salaro check (salario >0);
alter table enfermero add constraint CK_enfermero_turno check (turno in('M','T','N'));

create table paciente
(
	dni varchar(8) not null,
	nombre varchar(50) not null,
	apellido varchar(50) not null,
	direccion varchar(50),
	fecha_nacimiento date,
	diagnostico varchar(50)
);
exec sp_columns paciente;
alter table paciente add enfermero_atencion varchar(8);
alter table paciente drop column enfermero_atencion;
exec sp_helpconstraint paciente;
alter table paciente add constraint PK_paciente_dni primary key(dni);
alter table paciente add constraint FK_paciente_enfermero foreign key(enfermero_atencion) references enfermero(dni);

create table ocupacion
(
	codigo varchar(3) not null,
	hospital_cod varchar(2) not null,
	sala_cod varchar(2) not null
);
exec sp_columns ocupacion;
exec sp_helpconstraint ocupacion;
alter table ocupacion add constraint PK_ocupacion_codigo primary key(codigo);
alter table ocupacion add constraint FK_ocupacion_hospital foreign key(hospital_cod) references hospitales(hospital_cod);
alter table ocupacion add constraint FK_ocupacion_sala foreign key(sala_cod) references sala(sala_cod);
-------------------------------------------------------------------------------------------------------
--insertando valores a la tabla hospitales
exec sp_columns hospitales;
insert into hospitales values('11','Hospital Cajamarca','Av.Fray 144','965832147','100');
insert into hospitales values('14','Hospital Lima','Av.San Martin s/n','968532140','105');
insert into hospitales values('12','Hospital Chiclayo','La Victoria 12','975362140','101');
insert into hospitales values('13','Hospital Ica','Panamerica km 184','985741369','102');
insert into hospitales values('15','Hospital Huancayo','Av mauricio 54','975142336','104');
select * from hospitales order by 'hospital_cod' asc;
-------------------------------------------------------------------------------------------------------
--insertando valores a la tabla sala
exec sp_columns sala;
insert into sala values('20','UCI','200','11');
insert into sala values('21','UCI','201','12');
insert into sala values('22','UCI','202','13');
insert into sala values('23','UCI','203','14');
insert into sala values('24','UCI','204','15');

insert into sala values('31','CCU','301','15');
insert into sala values('32','CCU','302','11');
insert into sala values('33','CCU','303','12');
insert into sala values('34','CCU','304','13');
insert into sala values('35','CCU','305','14');

insert into sala values('41','UCIN','401','13');
insert into sala values('42','UCIN','402','11');
insert into sala values('43','UCIN','403','12');
insert into sala values('44','UCIN','404','14');
insert into sala values('45','UCIN','405','15');
select * from sala order by sala_cod;
-----------------------------------------------------------------------------------------------------
--insertando valores a la tabla enfermero
exec sp_columns enfermero;
insert into enfermero values('21452301','Cesar','Casas Casas','Cardiologo','M','4000.00','20','11');
insert into enfermero values('03521469','Jose','Prado Salas','Cardiologo','M','5000.00','21','12');
insert into enfermero values('6958210','Luis','Flores Flores','Cardiologo','M','4000.00','22','13');
insert into enfermero values('36201425','Alex','De la Torres','Cardiologo','M','4000.00','23','14');
insert into enfermero values('36952012','Maria','Agip Salas','Cardiologo','M','5000.00','24','15');

insert into enfermero values('36952148','Jhon','De la Cruz','Neurologo','T','6000.00','31','11');
insert into enfermero values('69853624','Lura','Flores Salas','Neurologo','T','6000.00','32','12');
insert into enfermero values('36589235','Maria','Vazquez Vazques','Neurologo','T','6000.00','33','13');
insert into enfermero values('36954215','Leslie','Guerra Velazques','Neurologo','T','6000.00','34','14');
insert into enfermero values('36958423','Camilo','Guerrero Flores','Neurologo','T','6000.00','35','15');

insert into enfermero values('65832569','Pedro','Barbosa Suarez','Dermatologo','N','4000.00','45','11');
insert into enfermero values('25478125','Jose','Garcia Casas','Dermatologo','N','4000.00','41','12');
insert into enfermero values('32568942','Pablo','Casas Guerra','Dermatologo','N','4000.00','42','13');
insert into enfermero values('02145789','Milagros','Hoyos Neyra','Dermatologo','N','4000.00','43','14');
insert into enfermero values('32547820','Claudia','Valdez Agip','Dermatologo','N','4000.00','44','15');
select * from enfermero order by hospital_cod;
----------------------------------------------------------------------------------------------------------------------
exec sp_columns paciente;
insert into paciente values('98754123','Juan','Perales Tacas','Av. jj36','11-02-1999','Problemas al corazon','21452301');
insert into paciente values('45823610','Rosa','Ortiz Gomez','Av. k36','12-08-2000','Problemas al corazon','03521469');
insert into paciente values('47851235','Maria','Suarez Belaunde','Av. m16','04-02-1985','Problemas al corazon','6958210');
insert into paciente values('41579362','Carina','Valle Tacas','Av. j54','10-8-1825','Problemas al corazon','36201425');
insert into paciente values('40321879','Jenni','Perales Ramos','Av. tt65','09-02-1996','Problemas al corazon','36952012');

insert into paciente values('25364892','Mateo','Perez Tacas','Av. er5','05-07-1999','Problemas de piel','36952148');
insert into paciente values('35478510','Eduardo','Aticama Flores','Av. wer6','06-02-1999','Problemas de piel','69853624');
insert into paciente values('36985214','Gema','Risco Flores','Av. dt5','06-02-1887','Problemas de piel','36589235');
insert into paciente values('21403007','Oscar','Mora Salas','Av. tg89','01-02-2015','Problemas de piel','36954215');
insert into paciente values('02314800','Raul','Martines Galdier','Av. df4','07-08-1994','Problemas de piel','36958423');

insert into paciente values('78543612','Aurora','Ramos Torres','Av. t856','20-08-1876','Problemas de vision','65832569');
insert into paciente values('78963125','Yolanda','Perales Prles','Av. dqw36','28-09-1987','Problemas de vision','25478125');
insert into paciente values('70213589','Felisa','Cass Artiaga','Av. uy66','30-12-1999','Problemas de vision','32568942');
insert into paciente values('78021036','Wilmer','Barturen Tacas','Av. bh53','29-11-1999','Problemas de vision','02145789');
insert into paciente values('70230140','Segundo','Valle Flores','Av. hf5','26-02-2013','Problemas de vision','32547820');

select * from paciente;
----realizando consultas
select * from paciente;
select nombre, apellido from paciente where nombre like 'A%';

select nombre, apellido, turno from enfermero where turno ='M' or turno ='T' order by turno;

select nombre, apellido, salario, funcion from enfermero where salario > 4000 and salario <6500 order by nombre asc;

select hospital_cod, nombre from hospitales order by nombre asc;

select dni, nombre, salario from enfermero where salario > (select avg(salario) from enfermero)

update paciente set direccion = 'Madrid 414' where direccion ='Av. t856';

select nombre, direccion from paciente where nombre = 'Aurora';

update paciente set direccion =(select direccion from paciente where dni ='78543612') where dni ='70230140';
select nombre, direccion from paciente where dni ='70230140';
select nombre,direccion from paciente where direccion ='Madrid 414';
--hola esto es una edicion desde github
