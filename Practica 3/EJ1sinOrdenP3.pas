{Para los ejercicios de esta parte de la práctica, teniendo en cuenta que los archivos no
están ordenados por ningún criterio, puede resultar necesario recorrer los archivos más
de una vez. La idea es resolver los ejercicios sin ordenar los archivos dados, y comparar
la eficiencia (en cuanto al número de lecturas/escrituras) de la solución brindada en esta
práctica respecto a la solución para el mismo problema considerando los archivos
ordenados.}

{El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente
información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos:

a. Se pide realizar un procedimiento que actualice el archivo maestro con el
archivo detalle, teniendo en cuenta que:

i. Los archivos no están ordenados por ningún criterio.

ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
del archivo detalle.

b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
archivo detalle?}

program actualizarStock;
const valorAbsurdo = -1;

type
  producto = record
    codigo: integer;
    nombre: string;
    precioVenta: real;
    stockActual: integer;
    stockMinimo: integer;
  end;

  venta = record
    codigoProducto: integer;
    cantidadVendida: integer;
  end;

  maestro = file of producto;
  detalle = file of venta;

procedure leer(var archivo: detalle; var v: venta);
begin
  if not eof(archivo) then
    read(archivo, v)
  else
    v.codigoProducto := valorAbsurdo; // Valor de código inválido para indicar fin de archivo
end;

procedure actualizarMaestro(var maestro: maestro; var detalle: detalle);
var
  regMaestro: producto;
  regDetalle: venta;
  encontrado: boolean;
begin
  reset(detalle);
  leer(detalle, regDetalle);
  while regDetalle.codigoProducto <> valorAbsurdo do //Mientras no se termina el archivo detalle
  begin
    encontrado := false;
    while not encontrado do //El end of file del maestro no lo pregunto porque si esta en el detalle esta en el maestro
    begin
      reset(maestro);
      read(maestro, regMaestro);
      if regMaestro.codigo = regDetalle.codigoProducto then
      begin
        // Actualizar el stock del producto en el maestro
        regMaestro.stockActual := regMaestro.stockActual - regDetalle.cantidadVendida;
        seek(maestro, filepos(maestro) - 1);
        write(maestro, regMaestro);
        encontrado := true; // Marcamos como encontrado para salir del bucle
      end;
      close(maestro);
    end;
    leer(detalle, regDetalle);
  end;
  close(detalle);
end;

var
  archivoMaestro: maestro;
  archivoDetalle: detalle;
begin
  assign(archivoMaestro, 'maestro.dat');
  assign(archivoDetalle, 'detalle.dat');
  
  // Actualizar el archivo maestro con el archivo detalle
  actualizarMaestro(archivoMaestro, archivoDetalle);
end.

