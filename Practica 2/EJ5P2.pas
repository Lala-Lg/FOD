{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}
program EJ5P2;

const valorAlto = 9999; N = 3; //son 30 sucursales y 30 archivos detalle, pruebo con 3;

type
  str = string [30];
  producto = record
    codigoProducto:integer;
    nombre:str;
    descripcion:str;
    stockDisponible:integer;
    stockMinimo: integer;
    precioProducto: real;
  end;

 sucursal = record
   codigoProducto:integer;
   cantidadVendida:integer;
 end;

 maestro = file of producto;
 detalle = file of sucursal;

 vectorDetalles = array [1..n] of detalle;
 vectorRegistros = array [1..n] of sucursal;

//Si llegué al final del archivo detalle, le entro al codigo un valor muy alto para saber que estoy al final.
procedure leer (var archivoDetalle:detalle; var dato:sucursal);
begin
  if (not eof (archivoDetalle)) then read (archivoDetalle,dato)
  else dato.codigoProducto := valorAlto;
end;

procedure minimo (var vD:vectorDetalles; var vR:vectorRegistros; var min:sucursal);
var i, indiceMin:integer;
begin
  indiceMin:= 0;
  min.codigoProducto:= valorAlto;
  for i:= 1 to N do begin
    if (vR[i].codigoProducto <> valorAlto) then begin
      if (vR[i].codigoProducto < min.codigoProducto) then begin
        min:= vR[i];
        indiceMin:= i;
      end;
    end;
    if (indiceMin <> 0) then leer(vD[indiceMin], vR[indiceMin]);
  end;
end;

procedure actualizaMaestro(var archivoMaestro:maestro; var mD:mergeDetalles; var mR:mergeRegistros);
var
  min:sucursal;
  i:integer;
  p:producto;
  totalVentasCodigo:integer;
  codigoActual:integer;
  nombre:string;
begin
  reset(archivoMaestro);
  for i:=1 to N do begin
    nombre:= 'Detalle' + 'i';
    assign(mD[i], nombre); //Al archivo en la posición i le asigno el nombre.
    rewrite(mD[i]); //Lo creo
    reset (mD[i]);
    leer (mD[i],mR[i]);
  end;
  minimo (mD,mR,min);
  while (min.codigoProducto <> valorAlto) do begin
    codigoActual:= min.codigoProducto;
    totalVentasCodigo:=0;
    while ((min.codigoProducto <> valorAlto) and (min.codigoProducto = codigoActual)) do begin
      totalVentasCodigo:= totalVentasCodigo + min.cantidadVendida; //voy sumando las cantidades vendidas en todas las sucursales, por código de producto.
      minimo(mD,mR,min);
    end;
    read (archivoMaestro, p);
    while (p.codigoProducto <> codigoActual) do read (archivoMaestro,p);
    seek(archivoMaestro, filepos(archivoMaestro)-1); //El puntero en la posición anterior a la que saltó la lectura.
    p.stockDisponible := p.stockDisponible - totalVentasCodigo;
    write(archivoMaestro,p);
  end;
  for i:=1 to N do close(mD[i]);
  close(archivoMaestro);
end;

procedure imprimirDetalle(var archivoDetalle: detalle);
var
  ventaDiaria:Sucursal;
begin
  reset(archivoDetalle);
  writeln('--- Archivo Detalle ---');
  while not eof(archivoDetalle) do
  begin
    read(archivoDetalle, ventaDiaria);
    writeln('Codigo de Producto: ', ventaDiaria.codigoProducto);
    writeln('Cantidad de Unidades Vendidas: ', ventaDiaria.cantidadVendida);
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
    writeln('Nombre Comercial: ', p.nombre);
    writeln('Descripcion del producto: ', p.descripcion);
    writeln('Precio de Venta: ', p.precioProducto:0:2);
    writeln('Stock Actual: ', p.stockDisponible);
    writeln('Stock Minimo: ', p.stockMinimo);
    writeln('');
  end;
  close(archivoMaestro);
end;

var m:maestro; d:detalle; mD:mergeDetalles; mR:mergeRegistro
begin
  actualizaMaestro(m,mD,mR);
end.
