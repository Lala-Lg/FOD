{A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.
}
program EJ4P2;
const valor_alto = 9999;
type
 datosProvincia = record
    nombreProvincia:string;
    codigoLocalidad:integer;
    cantAlfabetizados:integer;
    totalEncuestados:integer;
    end;
 datosLocalidad = record
   nombreProvincia:string;
   codigoLocalidad:integer;
   cantAlfabetizados:integer;
   cantEncuestados:integer;
 end;

maestro = file of datosProvincia; //Se dispone de los archivos por orden de localidad
detalle = file of datosLocalidad;

procedure leerDetalle (var archivo: detalle; var dato: datosLocalidad);
begin
  if (not (eof (archivo))) then read(archivo, dato)
  else dato.codigoLocalidad := valor_alto;
end;

procedure minimo(var det1, det2: detalle; var r1, r2, min: datosLocalidad);
begin
  if (r1.codigoLocalidad <= r2.codigoLocalidad) then
  begin
    min := r1;
    leerDetalle(det1, r1);
  end
  else
  begin
    min := r2;
    leerDetalle(det2, r2);
  end;
end;

procedure actualizarMaestro(var archivoMaestro: maestro; var det1,det2: detalle);
var
  registroMaestro: datosProvincia;
  r1,r2: datosLocalidad;
  codigoActual, total: integer;
  min: datosLocalidad;
begin
  reset(archivoMaestro); // Abrir el archivo maestro en modo lectura
  reset(det1); // Abrir el archivo detalle en modo lectura
  reset(det2);
  
  //Leer avisa cuando llego al final del detalle con valorAlto
  leerDetalle(det1, r1);
  leerDetalle(det2, r2);
  read (archivoMaestro, registroMaestro);
  minimo(det1,det2,r1,r2,min);

  while (min.codigoLocalidad <> valor_alto) do begin //Si no llegué al final de los archivo detalle
    codigoActual := min.codigoLocalidad;
    total:=0;

    while((min.codigoLocalidad <> valor_alto) and (min.codigoLocalidad = codigoActual)) do begin
       total:= total + min.cantEncuestados;
       minimo(det1,det2,r1,r2,min);
     end;

    while (registroMaestro.codigoLocalidad <> codigoActual) do begin
      //avanzo en el maestro hasta encontrar el producto que quiero actualizar
      read(archivoMaestro,registroMaestro);
      end;
    //Si encontré en el maestro, actualizo
    registroMaestro.totalEncuestados:=registroMaestro.totalEncuestados - total;
    seek(archivoMaestro, filepos(archivoMaestro)-1);
    write(archivoMaestro, registroMaestro);
   end;
  
  close(archivoMaestro); // Cerrar el archivo maestro
  close(det1); // Cerrar el archivo detalle 
  close(det2);
end;
 
var d1,d2:detalle; m:maestro;

begin

    actualizarMaestro(m, d1, d2);

end.
