create database DB_ControlAutobuses
go

use DB_ControlAutobuses
go
----------------------------Tablas--------------------------------------------
create table Tbl_Choferes(
 id_C int identity(1,1) primary key ,
 codigo_choferes as ('CH'+right('00'+CONVERT([varchar],id_C),(2))),
 nombre varchar(30) not null,
 apellido varchar(30) not null,
 fecha_nacimiento datetime not null,
 cedula nvarchar(20) not null unique
)
go

create table Tbl_Autobuses(
 id_A int identity(1,1) primary key ,
 codigo_autobuses as ('AUT'+right('00'+CONVERT([varchar],id_A),(2))),
 id_chofer int not null unique,
 marca varchar(30) not null,
 modelo varchar(30) not null,
 placa varchar(30) not null unique,
 color varchar(30) not null,
 año datetime not null,
constraint FK_Choferes foreign key (id_chofer) references Tbl_Choferes(id_C)
)
go

create table Tbl_Rutas(
 id_R int identity(1,1) primary key ,
 codigo_ruta as ('RT'+right('00'+CONVERT([varchar],id_R),(2))),
 id_chofer int not null unique,
 id_autobus int not null unique,
 ruta nvarchar(100) not null,
constraint FK_Choferes_R foreign key (id_chofer) references Tbl_Choferes(id_C),
constraint FK_Autobuses_R foreign key (id_autobus) references Tbl_autobuses(id_A)
)
go

drop table Tbl_Choferes
go
----------------------------Procedimientos-----------------------------------
create or alter proc SP_Guardar_Choferes
@nombre varchar(30),
@apellido  varchar(30),
@fecha_nacimiento datetime,
@cedula nvarchar(20)
as
insert into Tbl_Choferes (nombre, apellido, fecha_nacimiento, cedula) 
                   values(@nombre, @apellido, @fecha_nacimiento, @cedula)
go

create or alter proc SP_Editar_Choferes
@id int,
@nombre varchar(30),
@apellido varchar(30),
@fecha_nacimiento varchar(30),
@cedula nvarchar(20)
as
update Tbl_Choferes set  nombre = @nombre,
                         apellido = @apellido,
						 fecha_nacimiento = @fecha_nacimiento,
						 cedula = @cedula
						 where id_C = @id
go

create or alter proc SP_Buscar_Choferes
@id int
as
select * from Tbl_Choferes
         where id_C = @id
go

create or alter proc SP_Borrar_Choferes
@id int
as
delete from Tbl_Choferes
         where id_C = @id
go
--------------------------------------------------------------------------
create or alter proc SP_Guardar_Autobus
@id_Chofer int,
@marca varchar(30),
@modelo varchar(30),
@placa varchar(30),
@color varchar(30),
@año varchar(30)
as
insert into Tbl_Autobuses (id_chofer, marca, modelo, placa, color, año) 
                  values (@id_Chofer, @marca, @modelo, @placa, @color, @año)
go

create or alter proc SP_Editar_Autobus
@id int,
@id_Chofer int,
@marca varchar(30),
@modelo varchar(30),
@placa varchar(30),
@color varchar(30),
@año varchar(30)
as
update Tbl_Autobuses  set marca = @marca,
                         modelo = @modelo,
						 placa = @placa,
						 color = @color,
						 año = @año
						 where id_A = @id and 
						 id_chofer = @id_Chofer
go

create or alter proc SP_Buscar_Autobus
@id int,
@id_Chofer int
as
select * from Tbl_Autobuses
         where id_A = @id or 
		id_chofer = @id_Chofer
go

create or alter proc SP_Borrar_Autobus
@id int
as
delete from Tbl_Autobuses
         where id_A = @id  
go
------------------------------------------------------------------------------
create or alter proc SP_Guardar_Rutas
@id_Chofer int,
@id_Autobus int,
@ruta nvarchar(100)
as
insert into Tbl_Rutas (id_chofer, id_autobus, ruta) 
                values(@id_Chofer, @id_Autobus, @ruta)
go

create or alter proc SP_Editar_Rutas
@id int,
@id_Chofer int,
@id_Autobus int,
@ruta nvarchar(100)
as
update Tbl_Rutas set  ruta = @ruta
			    where id_R = @id and
                      id_chofer = @id_Chofer and
					  id_autobus = @id_Autobus
go

create or alter proc SP_Buscar_Rutas
@id int,
@id_Chofer int,
@id_Autobus int
as
select * from Tbl_Rutas
         where id_R = @id and
               id_chofer = @id_Chofer or
			   id_autobus = @id_Autobus
go

create or alter proc SP_Borrar_Rutas
@id int,
@id_Chofer int
as
delete from Tbl_Rutas
         where id_R = @id and
               id_chofer = @id_Chofer
go

------------------vistas---------------------------------

create view VW_choferes
as
select ch.codigo_choferes 'Codigo',
       ch.nombre 'Nombre',
       ch.apellido 'Apellido',
	   ch.cedula 'Cedula',
	   ch.fecha_nacimiento 'Fecha Nacimiento'
from Tbl_Choferes ch
go

create or alter view VW_Autobuses
as
select ch.codigo_choferes 'Codigo Chofer',
       ch.nombre 'Nombre',
	   ch.cedula 'Cedula',
       aut.codigo_autobuses 'Codigo Autobus',
       aut.marca 'Marca',
	   aut.modelo 'Modelo',
	   aut.color 'Color',
	   aut.placa 'Placa',
	   aut.año 'Año'      
from Tbl_Choferes ch, 
     Tbl_Autobuses aut
where aut.id_chofer = ch.id_C 
go

create view VW_Rutas
as
select rt.codigo_ruta 'Codigo Ruta',
       rt.ruta 'Ruta',
	   ch.codigo_choferes 'Codigo Chofer',
       ch.nombre 'Nombre',
	   ch.cedula 'Cedula',
       aut.codigo_autobuses 'Codigo Autobus',
       aut.marca 'Marca',
	   aut.modelo 'Modelo',
	   aut.placa 'Placa'	   
from Tbl_Choferes ch, 
     Tbl_Autobuses aut,
	 Tbl_Rutas rt
where rt.id_chofer = ch.id_C and
      rt.id_autobus = aut.id_A
go