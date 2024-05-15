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
  //No es necesario leer, solo que lo hago para probar el programa más tarde. El enunciado dice que se da la información para el archivo ordenada por código.
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

//PROBLEMA: NO ACTUALIZA EL ÚLTIMO PRODUCTO DEL MAESTRO.
procedure actualizarMaestroConDetalle(var archivoMaestro: maestro; var archivoDetalle: detalle);
var
  productoMaestro: producto;
  ventaDetalle: ventaDiaria;
  codigoActual, total: integer;
begin
  reset(archivoMaestro); // Abrir el archivo maestro en modo lectura
  reset(archivoDetalle); // Abrir el archivo detalle en modo lectura
  
  read(archivoDetalle, ventaDetalle);
  read(archivoMaestro, productoMaestro); 
  
  while (not eof(archivoMaestro) and not eof(archivoDetalle)) do
  begin
    codigoActual := productoMaestro.codigoProducto;
    total := 0;
    
    while (not eof(archivoDetalle) and (ventaDetalle.codigoProducto = codigoActual)) do
    begin
      total := total + ventaDetalle.cantUnidadesVendidas;
      read(archivoDetalle, ventaDetalle); // Leer siguiente registro del detalle
    end;
    
    if (codigoActual = productoMaestro.codigoProducto) then
    begin
      productoMaestro.stockActual := productoMaestro.stockActual - total;
      seek(archivoMaestro, filepos(archivoMaestro) - 1); // Retroceder a la posición del registro leído
      write(archivoMaestro, productoMaestro); // Escribir el registro actualizado
    end;
    
    if (not eof(archivoMaestro)) then
      read(archivoMaestro, productoMaestro); // Leer siguiente registro del maestro
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

//Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo stock actual esté por debajo del stock mínimo permitido.

//Para escribir en un txt hay que escribir campo por campo... F
procedure buscarProductos(var m: maestro; var archivoTxt: Text);
var
  p: producto;
begin
  reset(m); //Abro el archivo maestro para buscar entre los productos.
  assign(archivoTxt, 'stock_minimo.txt');
  rewrite(archivoTxt); // Abro el archivo de texto en modo escritura
  while not eof(m) do begin
    read(m, p);
    if (p.stockActual < p.stockMinimo) then begin
      // Si el stock actual es menor que el stock mínimo, escribir en el archivo de texto
      writeln(archivoTxt, 'Codigo de Producto: ', p.codigoProducto);
      writeln(archivoTxt, 'Nombre Comercial: ', p.nombreComercial);
      writeln(archivoTxt, 'Precio de Venta: ', p.precioVenta:0:2);
      writeln(archivoTxt, 'Stock Actual: ', p.stockActual);
      writeln(archivoTxt, 'Stock Minimo: ', p.stockMinimo);
      writeln(archivoTxt, '');
    end;
  end;
  close(m);
  close(archivoTxt); // Cerrar el archivo de texto
end;

//Nota, importante: al menos Geany no va a ejecutar correctamente este código si lo divido por procesos.. como por ejemplo
//yo había querido hacer los writeln dentro de un proceso llamador "escribir en txt" o algo así. También había separado el crear txt poniendo el
//assign en otro proceso... Resultó en que no me escribía en el txt lo que le pedía. Opté por poner todo junto en "buscar producto" y funcionó.
//Quizás en el parcial da igual separarlo por procesos si total no hay que ejecutarlo, es en papel.


//Me faltó el menu.
var m:maestro; d:detalle; archivoTxt:Text;
begin

  crearMaestro(m);
  crearDetalle(d);
  imprimirDetalle(d);
  imprimirMaestro(m);
  actualizarMaestroConDetalle(m,d);
  imprimirMaestro(m);
  buscarProductos(m,archivoTxt);
  
end.
