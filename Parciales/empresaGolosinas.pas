{Parcial de archivos secuenciales, 8/08/2023 tercera fecha.
Una empresa dedicada a la venta de golosinas posee un archivo que contiene información sobre los productos que tiene a la venta. De cada producto se registran los siguientes datos:
código de producto, nombre comercial, precio de venta, stock actual y minimo.

La empresa cuenta con 20 sucursales de las que diariamente recibe un archivo detalle de cada una de las 20 sucursales de la empresa que indica las ventas diarias efectuadas por la sucursal.
De cada venta se registra el código de producto y cantidad vendida. Se debe realizar un procedimiento que actualice el stock en el archivo maestro con la información disponible en los archivos detalles
y que además informe en un archivo de texto aquellos productos cuyo monto total vendido en el día supere los 10.000 pesos. 
En el archivo de texto a exportar, por cada producto incluido se deben informar todos los sus datos. Los datos de un producto se debe organizar en el archivo de texto para facilitar el uso eventual del mismo como un archivo de carga.

El objetivo del ejercicio es escribir el procedimiento solicitado, junto con las estructuras de datos y módulos usados en el mismo.

Notas:

Todos los archivos se encuentran ordenados por código de producto.
En un archivo detalles pueden haber 0, 1 o n registros de un producto determinado.
Cada archivo detalle solo contiene productos que seguro existen en el archivo maestro.
Los archivos se deben recorrer una sola vez. En el mismo recorrido se debe realizar la actualización del archivo maestro
con los archivos detalles, así como la generación del archivo de texto solicitado. }

program parcial;
const n=20; valorAlto=9999;
type
  producto = record
  codigoProducto:integer;
  nombre:string;
  precio:real;
  stockActual:integer;
  stockMinimo:integer;
  end;
  venta = record
  codigoProducto:integer;
  cantVendida:integer;
  end;
  
  maestro = file of producto;
  detalle = file of venta;
  
  detalles = array [1..n] of Detalle;
  sucursales = array [1..n] of Venta;
  
//Ya se poseen los archivos.

procedure leer (var archivoDetalle:detalle;var dato:venta);
begin
  if(not eof(archivoDetalle)) then read (archivoDetalle,dato)
  else dato.codigoProducto:=valorAlto;
end;

procedure minimo (var vD:detalles; var vS:sucursales; var min:venta);
var i, indiceMin:integer;
begin
  min.codigoProducto:=valorAlto;
  for i:=1 to n do begin
    if(vS[i].codigoProducto < min.codigoProducto) then begin
      min:=vS[i];
      indiceMin:=i;
      end;
  end;
  if(indiceMin<>0) then leer(vD[indiceMin],vS[indiceMin]);
end;

procedure cargarTXT(var archivoTxt:text;p:producto;total:real);
var montoTotal:real;
begin
  montoTotal:=p.precio*total;
  if(montoTotal>10.000)then 
    writeln(archivoTxt,p.codigoProducto,p.precio,p.stockActual,p.stockMinimo,p.nombre);
end;

procedure actualizar (var archivoMaestro:maestro; var vS:sucursales; vD:detalles; var archivoTxt:text);
var min:venta; i:integer; p:producto; totalVendido:integer; codigoActual:integer;
begin
  assign (archivoTxt,'superaMontoTotal.txt'); rewrite(archivoTxt);
  reset(archivoMaestro);
  for i:=1 to n do begin
    reset(vD[i]);
    end;
  minimo(vD,vS,min);
  while(min.codigoProducto<>valorAlto) do begin
    codigoActual:=min.codigoProducto;
    totalVendido:=0;
    while(min.codigoProducto=codigoActual) do begin
      totalVendido:=totalVendido + min.cantVendida;
      minimo(vD,vS,min);
      end;
    read(archivoMaestro,p);
    while(p.codigoProducto<>codigoActual) do read(archivoMaestro,p);
    seek(archivoMaestro,filepos(archivoMaestro)-1);
    p.stockActual:=p.stockActual-totalVendido;
    write(archivoMaestro,p); 
    cargarTXT(archivoTxt,p,totalVendido);
  end;
  for i:=1 to n do close(vD[i]);
  close(archivoMaestro);
end;

procedure imprimirArchivoTxt(var archivoTxt:text);
var linea: string;
begin
  // Abre el archivo de texto en modo lectura
  assign(archivoTxt, 'superaMontoTotal.txt');
  reset(archivoTxt);

  // Lee y muestra cada línea del archivo
  while not EOF(archivoTxt) do
  begin
    ReadLn(archivoTxt, linea);
    writeln(linea);
  end;

  // Cierra el archivo
  Close(archivoTxt);
end;

var archivoMaestro:maestro;vS:sucursales;vD:detalles;archivoTxt:text;
begin
actualizar(maestro,vS,vD,archivoTxt);
imprimirArchivoTxt(archivoTxt);
end.
