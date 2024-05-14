program EJ3P2;

type
  producto = record
   codigoProducto: integer;
   nombreComercial: string;
   precioVenta: real;
   stockActual:integer;
   stockMinimo:integer;
  end;
  
  ventaDiaria = record
  codigoProducto:integer;
  cantUnidadesVendidas:integer;
  end;
  
  maestro = file of producto;
  detalle = file of ventaDiaria;
  
  //Información sobre el producto que se almacene en la variable producto.
  procedure leerProducto (var p:producto);
  begin
    with p do begin 
        writeln('Productos');
		write ('Ingrese codigo de producto: '); readln (codigoProducto);
		if (codigoProducto <> -1) then begin
			write ('Nombre comercial: '); readln (nombreComercial);
			write ('Stock disponible: '); readln (stockActual);
			write ('Stock minimo: '); readln (stockMinimo);
			write ('Precio de venta: '); readln (precioVenta);
		end;
		writeln ('');
	end;
 end;
 procedure leerVentaDiaria(var v:ventaDiaria);
 begin
   with v do begin
     writeln('Venta diaria');
     write ('Ingrese codigo de producto: '); readln (codigoProducto);
		if (codigoProducto <> -1) then begin
       write('Cantidad de unidades vendidas hoy: '); read(cantUnidadesVendidas);
     end;
   end;
end;

//Como no dice de donde se carga, si ya esta en un archivo txt o qué entonces lo creo yo. Pero también podría haber copiado de un txt al binario.        
procedure crearMaestro(var m: maestro);
var
  p: producto;
  nombre: string;
begin
  nombre := 'archivoMaestro';
  assign(m,nombre);
  rewrite(m); //Creo el archivo binario maestro.
  reset(m);
  writeln('Para dejar de ingresar productos, ingresar codigo de producto -1');
  leerProducto(p);
  while (p.codigoProducto <> -1) do begin
    //Escribe el producto en el archivo binario maestro
    write(m, p);
    leerProducto(p);
  end;
  close(m); // Cierra el archivo binario maestro.
end;

procedure crearDetalle(var d:detalle);
var
  v:ventaDiaria;
  nombre: string;
begin
  nombre := 'archivoDetalle';
  assign(d,nombre);
  rewrite(d);
  reset(d);
  writeln('Para dejar de ingresar las ventas diarias, ingresar codigo de producto -1');
  leerVentaDiaria(v);
  while(v.codigoProducto <> -1) do begin
    write(d,v);
    leerVentaDiaria(v);
  end;
  close(d);
end;

//Actualizar el archivo maestro con el archivo detalle.

procedure actualizarMaestroConDetalle(var archivoMaestro: maestro; var archivoDetalle: detalle);
var
  productoMaestro: producto;
  ventaDetalle: ventaDiaria;
begin
  reset(archivoMaestro); // Abrir el archivo maestro en modo lectura
  reset(archivoDetalle); // Abrir el archivo detalle en modo lectura
  while not eof(archivoMaestro) and not eof(archivoDetalle) do
  begin
    read(archivoMaestro, productoMaestro); // Leer un registro del archivo maestro
    read(archivoDetalle, ventaDetalle); // Leer un registro del archivo detalle

    if productoMaestro.codigoProducto = ventaDetalle.codigoProducto then
    begin
      // Actualizar el stock actual del producto en el archivo maestro
      productoMaestro.stockActual := productoMaestro.stockActual - ventaDetalle.cantUnidadesVendidas;
      // Volver al registro leído y escribir la actualización
      seek(archivoMaestro, filepos(archivoMaestro) - 1);
      write(archivoMaestro, productoMaestro);
    end;
  end;
  close(archivoMaestro); // Cerrar el archivo maestro
  close(archivoDetalle); // Cerrar el archivo detalle
end;

procedure imprimirDetalle(var archivoDetalle: detalle);
var
  v: ventaDiaria;
begin
  reset(archivoDetalle);
  writeln('--- Archivo Detalle ---');
  while not eof(archivoDetalle) do
  begin
    read(archivoDetalle, v);
    writeln('Codigo de Producto: ', v.codigoProducto);
    writeln('Cantidad de Unidades Vendidas: ', v.cantUnidadesVendidas);
    writeln('');
  end;
  close(archivoDetalle);
end;

procedure imprimirMaestro(var archivoMaestro: maestro);
var
  p: producto;
begin
  reset(archivoMaestro);
  writeln('--- Archivo Maestro ---');
  while not eof(archivoMaestro) do
  begin
    read(archivoMaestro, p);
    writeln('Codigo de Producto: ', p.codigoProducto);
    writeln('Nombre Comercial: ', p.nombreComercial);
    writeln('Precio de Venta: ', p.precioVenta:0:2);
    writeln('Stock Actual: ', p.stockActual);
    writeln('Stock Minimo: ', p.stockMinimo);
    writeln('');
  end;
  close(archivoMaestro);
end;

var m:maestro; d:detalle;
begin

  crearMaestro(m);
  crearDetalle(d);
  imprimirDetalle(d);
  imprimirMaestro(m);
  actualizarMaestroConDetalle(m,d);
  imprimirMaestro(m);
  
end.
