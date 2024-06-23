{Una cadena de restaurantes posee un archivo de productos que tiene a la venta, de cada producto se registra: código de producto, nombre,
descripción, código de barras, categoría de producto, stock actual, stock mínimo.
Diariamente el depósito debe efectuar envíos a los restaurantes que se encuentran en la ciudad. Para esto, cada uno envía un archivo por email de los pedidos.
Cada pedido contiene: código de producto, cantidad pedida y una descripcion.
Se pide realizar un proceso de actualización de archivo maestro con los TRES archivo detalle.}
program parcialCadenaRestaurantes;
Const n = 3; valorAlto = 999;
type 
  producto = record
  codigoProducto:integer;
  nombre:string;
  descripcion:string;
  codigoBaras:integer;
  categoria:string;
  stockActual:integer;
  stockMinimo:integer;
  end.
  pedido = record
  codigoProducto:integer;
  cantPedida:integer;
  descripcion:string;
  end;
  //Actualizacion del maestro con 3 detalles.
  //Obtener informe de los productos que quedaron por debajo del stock minimo
  //Y a qué categoría pertenecen.
  //Informar aquellos pedidos que no pudieron satisfacerse por falta de stock.
  //Para eso informar la diferencia que no se pudo enviar a c/ restaurante.
  //Si el stock no es suficiente igual debe satisfacerse con lo que haya en stock.
  
  //Todos los archivos estan ordenados por código de producto.
  maestro = file of producto;
  detalle = file of pedido;
  
  vectorDetalles = array [1..n] of detalle;
  vectorRegistros = array [1..n] of pedido;
  
  procedure leer (var archivoDetalle:detalle; var dato:pedido);
  begin
    if (not eof (archivoDetalle)) then read (archivoDetalle,dato)
    else dato.codigoProducto := valorAlto;
  end;
  
  procedure minimo (var vD: vectorDetalles; var vR:vectorRegistros; var min:pedido);
  var i, indiceMin:integer;
  begin
    indiceMin:=0;
    min.codigoProducto:= valorAlto;
    for i:=1 to n do begin
      if(vR[i].codigoProducto < min.codigoProducto) then begin
         min:= vR[i];
         indiceMin:= i;
      end;
      if (indiceMin<>valorAlto) then leer(vD[indiceMin], vR[indiceMin]);
    end;
  end;
  
  procedure actualizarMaestro(var archivoMaestro:maestro; var vD:vectorDetalles; var vR:vectorRegistros);
  var
    min:pedido;
    i:integer;
    p:producto;
    diferenciaStock:integer:
    codigoActual:integer;
    pedidoTotal:integer;
  begin
    reset(archivoMaestro);
    for i:=1 to n do begin
      reset(vD[i]);
      leer(vD[i],vR[i]);
    end;
    minimo (vD,vR,min);
    while (min.codigoProducto <> valorAlto) do begin
      codigoActual:= min.codigoProducto;
      pedidoTotal:=0;
      diferenciaStock:=0;
      while(min.codigoProducto = codigoActual)do begin
        pedidoTotal:=pedidoTotal + min.cantPedida;
        minimo(vD,vR,min);
      end;
      read (archivoMaestro,p);
      while(p.codigoProducto <> codigoActual) do read(archivoMaestro,p);
      seek(archivoMaestro, filepos(archivoMaestro)-1);
      if (p.stockActual >= pedidoTotal) then
         p.stockActual:= p.stockActual - pedidoTotal
      else begin 
           diferenciaStock = pedidoTotal - p.stockAcutal;
           p.stockActual:= 0;
           writeln('No se pudo satisfacer el pedido por diferencia total de: ', diferenciaStock);
           end;
      if (p.stockActual < p.stockMinimo) then
        writeln('El producto ', p.nombre, ' quedó por debajo del stock minimo. Este pertenece a la categoria: ', p.categoria);
      write(archivoMaestro,p);
   end;
   for i:=1 to n do close(vD[i]);
   close(archivoMaestro);
end;
var
  m: maestro;
  vD: vectorDetalles;
  vR: vectorRegistros;
  i: integer;
begin
  assign(m, 'archivoMaestro.dat');
  for i := 1 to n do
    assign(vD[i], 'detalle' + IntToStr(i) + '.dat');
  actualizarMaestro(m, vD, vR);
end.
