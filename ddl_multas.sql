/*Crear Propietario*/
CREATE TABLE Propietario(
   RFC        VARCHAR(13) NOT NULL
  ,Nombre     VARCHAR(50) NOT NULL 
  ,Paterno    VARCHAR(50) NOT NULL
  ,Materno    VARCHAR(50) NOT NULL
  ,Calle      VARCHAR(50) 
  ,Numero     INTEGER  CHECK (Numero >= 0 or Numero is NULL)
  ,CP         CHAR(5) 
  ,Estado     VARCHAR(50) 
  ,Municipio  VARCHAR(50) 
  ,Nacimiento DATE  NOT NULL
  ,Genero     CHAR(1) NOT NULL CHECK (Genero = 'H' or Genero = 'M')
  ,CONSTRAINT Propietario_pkey PRIMARY KEY (RFC)
);

/*Crear Vehiculo*/
CREATE TABLE Vehiculo(
   numPlaca               VARCHAR(6) NOT NULL
  ,Modelo                 VARCHAR(50) NOT NULL
  ,Marca                  VARCHAR(50) NOT NULL
  ,CapTanque              INTEGER  NOT NULL CHECK (CapTanque > 0)
  ,Pasajeros              INTEGER  NOT NULL CHECK (Pasajeros > 0)
  ,numMotor               INTEGER  NOT NULL CHECK (numMotor > 0)
  ,LitrosMotor            INTEGER  NOT NULL CHECK (LitrosMotor > 0)
  ,Cilindros              INTEGER  NOT NULL CHECK (Cilindros > 0)
  ,Transmision            VARCHAR(20) NOT NULL CHECK (Transmision = 'estandar' or 
													 Transmision = 'automatico')
  ,CalcomaniaVerificacion INTEGER CHECK (CalcomaniaVerificacion between 0 and 9 or
										CalcomaniaVerificacion is NULL)
  ,FechaVerificacion      DATE 
  ,Anio                   INTEGER  NOT NULL CHECK (Anio > 0)
  ,CONSTRAINT Vehiculo_pkey PRIMARY KEY (numPlaca)
);

/*Crear Poseer*/
CREATE TABLE Poseer(
   numPlaca     VARCHAR(6) NOT NULL UNIQUE
  ,RFC          VARCHAR(13) NOT NULL
  ,FechaCompra  DATE  NOT NULL
  ,PrecioCompra INTEGER  NOT NULL CHECK (PrecioCompra > 0)
  ,CONSTRAINT Poseer_fkey1 FOREIGN KEY (numPlaca) REFERENCES Vehiculo(numPlaca) 
	ON UPDATE CASCADE ON DELETE CASCADE
  ,CONSTRAINT Poseer_fkey2 FOREIGN KEY (RFC) REFERENCES Propietario(RFC)
	ON UPDATE CASCADE ON DELETE SET NULL
);

/*Crear Licencia*/
CREATE TABLE Licencia(
   numLicencia CHAR(12)  NOT NULL
  ,RFC         VARCHAR(13) NOT NULL
  ,Tipo        CHAR(1) CHECK (Tipo between 'A' and 'F')
  ,Fecha       DATE  NOT NULL
  ,Vigencia    INTEGER  NOT NULL CHECK (Vigencia between 2017 and 2027)
  ,CONSTRAINT Licencia_pkey PRIMARY KEY (numLicencia)
  ,CONSTRAINT Licencia_fkey FOREIGN KEY (RFC) REFERENCES Propietario(RFC) 
	ON UPDATE CASCADE ON DELETE CASCADE
);

/*Crear TarjetaCirculacion*/
CREATE TABLE TarjetaCirculacion(
   numLicencia CHAR(12)  NOT NULL
  ,numPlaca    CHAR(6) NOT NULL
  ,Fecha       DATE  NOT NULL
  ,Vigencia    INTEGER  NOT NULL CHECK (Vigencia between 2017 and 2027)
  ,CONSTRAINT TarjetaCirculacion_pkey PRIMARY KEY (numLicencia)
  ,CONSTRAINT TarjetaCirculacion_fkey FOREIGN KEY (numPlaca) REFERENCES Vehiculo(numPlaca)
	ON UPDATE CASCADE ON DELETE CASCADE
);

/*Crear Multa*/
CREATE TABLE Multa(
   numMulta   INTEGER  NOT NULL CHECK(numMulta > 0)
  ,RFC        VARCHAR(13) NOT NULL
  ,numPlaca   VARCHAR(6) NOT NULL
  ,NumAgente  INTEGER  NOT NULL CHECK(NumAgente between 150 and 270)
  ,Fecha      DATE  NOT NULL
  ,Calle      VARCHAR(50)
  ,Entre1     VARCHAR(50) 
  ,Entre2     VARCHAR(50) 
  ,CP         CHAR(5)  NOT NULL
  ,Municipio  VARCHAR(50) NOT NULL
  ,Referencia VARCHAR(150) 
  ,CONSTRAINT Multa_pkey PRIMARY KEY (numMulta)
  ,CONSTRAINT Multa_fkey1 FOREIGN KEY (RFC) REFERENCES Propietario(RFC)
	ON UPDATE CASCADE ON DELETE CASCADE
  ,CONSTRAINT Multa_fkey2 FOREIGN KEY (numPlaca) REFERENCES Vehiculo(numPlaca)
	ON UPDATE CASCADE ON DELETE SET NULL
);

/*Crear Articulo*/
CREATE TABLE Articulo(
   numMulta       INTEGER  NOT NULL CHECK(numMulta > 0)
  ,Articulo       VARCHAR(100) NOT NULL CHECK(Articulo between 
								'Articulo-00' and 'Articulo-69')
  ,PrecioArticulo NUMERIC  NOT NULL CHECK(PrecioArticulo > 0)
  ,CONSTRAINT Articulo_pkey PRIMARY KEY (numMulta,Articulo)
  ,CONSTRAINT Articulo_fkey FOREIGN KEY (numMulta) REFERENCES Multa(numMulta)
	ON UPDATE CASCADE ON DELETE CASCADE
);