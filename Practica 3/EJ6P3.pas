{
Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.
}
program EJ6P3;
const valorAlto = 999;
type
 codPrenda=integer;
 prenda = record
        codigo:codPrenda;
        descripcion:string[30];
        colores:string[10];
        tipoPrenda:string[10];
        stock:integer;
        precioUnitario:real;
    end;
 maestro = file of prenda;
 detalle = file of codPrenda;
 //dispongo de ambos archivos, maestro y detalle.
procedure leerDetalle (var arc_log:detalle; var dato:codPrenda);
begin
	if not eof (arc_log) then
		read (arc_log,dato)
	else
		dato:= valorAlto;
end;
 procedure bajaLogica (var m:maestro; var d:detalle);
 var codigo:codPrenda; p:prenda;
 begin
   reset (m);
   reset (d);
   leerDetalle(d,codigo);
   while (codigo <> valorAlto) do begin
     read(m,p);
     while(p.codigo <> codigo) do read(m,p);
     p.stock := (-1)*p.stock;
     seek(m,filepos(m)-1);
     write(m,p);
     read(d,codigo);
   end;
   close(m); close(d);
 end;
 procedure leerMaestro (var arc_log:maestro; var dato:prenda);
begin
	if not eof (arc_log) then
		read (arc_log,dato)
	else
		dato.codigo:= valorAlto;
end;
 procedure bajaFisica (var m:maestro; var mNuevo:maestro);
 var p:prenda;
 begin
   reset (m);
   assign(mNuevo,'maestroNuevo.dot');
   rewrite(mNuevo);
   leerMaestro(m,p);
   while (p.codigo <> valorAlto) do begin
   if (p.stock >= 0) then write (mNuevo,p);
   leerMaestro(m,p);
   end;
   close(m);
   close(mNuevo);
   erase(m);
   rename(mNuevo,'maestro.dot');
 end;
var m:maestro; d:detalle; mNuevo:maestro;
begin
  bajaLogica(m,d);
  bajaFisica(m,mNuevo);
end.
     
   
     
 
