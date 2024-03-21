--6 a)
select NumAgente, 
	extract('year' from fecha) as Año, 
	extract('quarter' from fecha) as Trimestre,
	count(numMulta) "NumMultas"
from Multa
group by NumAgente, extract('year' from fecha), extract('quarter' from fecha)
order by 1,2,3;

--6 b)
select numMulta,nombre,paterno,materno,nacimiento,fecha as fechaMulta
from multa natural join propietario
where extract('day' from nacimiento) = extract('day' from fecha) and
	extract('month' from nacimiento) = extract('month' from fecha);
	
--6 c)
select b.RFC, b.numplaca, c.numLicencia, a.nombre, 
		a.paterno, a.materno, c.Vigencia
from propietario a join poseer b on a.rfc = b.rfc join
	tarjetaCirculacion c on b.numPlaca = c.numPlaca
where Vigencia <= 2022
order by 4,5,6;

 /*6 c) (opcion 2) ---> para visualizar solamente los nombres de los propietarios 
 con tc vencida sin repeticion (pues un propietario puede tener 2 o mas vehiculos 
 y por tanto, 2 o mas tc vencidas al 07/12/2022*/
select distinct b.RFC, a.nombre, 
		a.paterno, a.materno
from propietario a join poseer b on a.rfc = b.rfc join
	tarjetaCirculacion c on b.numPlaca = c.numPlaca
where Vigencia <= 2022
order by 2,3,4;  

--6 d)
select fecha as fechamulta, numagente, a.numplaca, modelo, marca, capTanque, 
	pasajeros, numMotor, litrosMotor, Cilindros, transmision, calcomaniaVerificacion,
	FechaVerificacion, anio
from multa a join vehiculo b on a.numPlaca = b.numPlaca
where extract('quarter' from fecha) = 4 and extract('year' from fecha) = 2020
order by fecha,numagente;

--6 e)
select estado, municipio, genero, paterno, materno, nombre, count(RFC) as numautos
from propietario natural join poseer
group by estado, municipio, genero, nombre, paterno, materno
order by 1,2,3;

--6 f)
select nummulta, a.RFC, genero, paterno, materno, nombre, numero, a.cp,
		a.estado, a.municipio
from propietario a left join multa b on a.RFC = b.RFC
where b.nummulta is null and genero = 'H'
order by a.RFC;

--6 g)
select Vigencia as Vigencia_licencia,
	numPlaca, modelo, marca, captanque, pasajeros, nummotor, 
	litrosmotor,cilindros, transmision, calcomaniaverificacion,
	fechaverificacion,anio
from vehiculo natural join poseer natural join propietario natural join licencia
where vigencia <= 2022;

--6 h)
select nummulta, a.RFC, genero, paterno, materno, nombre, numero, a.cp,
		a.estado, a.municipio
from propietario a left join multa b on a.RFC = b.RFC
where b.nummulta is not null and paterno = 'Molina' and estado = 'Chiapas'
order by a.RFC;
--6 i)
SELECT Propietario.*, Vehiculo.* FROM (Propietario JOIN Multa ON Multa.RFC=Propietario.RFC)
JOIN Vehiculo ON Multa.numPlaca=Vehiculo.numPlaca
WHERE Vehiculo.fechaverificacion < '2022-12-07';

--6 j)
select a.marca, nummulta, rfc, b.numplaca, numagente, fecha, calle, entre1,
		entre2, cp, municipio, referencia
from vehiculo a right join multa b on a.numplaca = b.numplaca 
where b.nummulta is not null and extract(year from b.fecha) = 2022 and marca = 'VW';

--6 k)
select d.*, c.calcomaniaverificacion
from (vehiculo a full join poseer b on a.numplaca = b.numplaca) c
		full join propietario d on c.rfc  =  d.rfc
where d.genero = 'M' and c.calcomaniaverificacion = 0;

--6 l)
select Nombre as Propietarios, estado, genero, marca
from Propietario natural join Vehiculo
group by estado, genero, marca, Nombre
order by 2,3,4;

--6 m)
select municipio,nombre,paterno,materno,nacimiento,precioCompra
from propietario natural join poseer
where propietario.municipio ='Guerrero' and poseer.preciocompra > 80000;

--6 n)
select b.fechacompra,a.*  
from vehiculo a right join poseer b on a.numplaca = b.numplaca
where a.transmision = 'automatico' and b.fechacompra >= cast('2022-01-01' as date)
		and b.fechacompra <= cast('2022-12-07' as date)
order by 1;

--6 o)
select articulo.precioarticulo as Importe_multa, propietario.* 
from (articulo right join multa on articulo.nummulta = multa.nummulta)
		left join propietario on multa.rfc = propietario.rfc
where estado = 'Puebla' and articulo.precioarticulo >= 500
order by 1;

--6 p)
select c.marca,c.nummulta,d.*
from (vehiculo a full join multa b on a.numplaca = b.numplaca) c
		full join propietario d on c.rfc = d.rfc
where c.marca = 'Ford' and c.nummulta is not null 
		and extract(year from d.nacimiento) <= 1987 
		and extract(year from d.nacimiento) >= 1967;

--6 q)
SELECT Propietario.*, Vehiculo.* FROM (Propietario JOIN Multa ON Multa.RFC=Propietario.RFC)
JOIN Vehiculo ON Multa.numPlaca=Vehiculo.numPlaca
WHERE (Multa.numMulta is not null AND Multa.numPlaca LIKE '%ALV%');

--6 r)
SELECT Vehiculo.* FROM (Propietario JOIN Multa ON Multa.RFC=Propietario.RFC)
JOIN Vehiculo ON Multa.numPlaca=Vehiculo.numPlaca
WHERE Vehiculo.pasajeros =4 AND Propietario.genero = 'H';

--6 s)
select Vehiculo.*
from Multa left outer join Vehiculo on Multa.numPlaca = vehiculo.numPlaca 
where vehiculo.anio > 2020;

--6 t)
select Paterno
from Propietario
where Paterno ~* '.* [adgjlpr]';

--6 u)
SELECT Multa.* FROM Multa JOIN Propietario ON Multa.RFC = Propietario.RFC 
WHERE Propietario.Calle LIKE 'San%';

--6 v)
SELECT Vehiculo.* FROM Vehiculo JOIN Multa ON Vehiculo.numPlaca = Multa.numPlaca
WHERE Vehiculo.transmision = 'estandar' AND Multa.NumAgente = 200;

--6 w)
select marca ,articulo.nummulta, count(articulo) "Articulo"
from (articulo join multa on articulo.nummulta = multa.nummulta)
		 join vehiculo on multa.numplaca = vehiculo.numplaca
where marca = 'Kia'
group by articulo.nummulta,marca
order by 1;

--6 x)
select marca,modelo,Anio, count(numPlaca) as nummultas 
from vehiculo natural join multa 
group by marca,modelo,Anio 
order by 1,2,3;

--6 y)
select nummulta, vehiculo.*
from vehiculo left join multa on vehiculo.numplaca = multa.numplaca
where nummulta is null and marca = 'Honda';

