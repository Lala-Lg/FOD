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

maestro = file of datosProvincia;
detalle = file of datosLocalidad;

//No es necesario crear el binario a partir de un archivo de texto. Lo que pasa es que como dice que se provee y que ya vienen ordenados en el enunciado... La idea es probarlo.
procedure crearMaestro(var m: maestro; var archivoTxt:Text);
var dProvincia: datosProvincia; nombre:string;
begin
  nombre := 'archivoMaestro';
  assign (m,nombre);
  rewrite (m);
  reset (archivoTxt);
  while (not eof (archivoTxt)) do begin
    readln(archivoTxt, dProvincia.nombreProvincia, dProvincia.codigoLocalidad, dProvincia.cantAlfabetizados, dProvincia.totalEncuestados);
    write(m,dProvincia);
  end;
  close (archivoTxt);
  close (m);
end;

procedure crearDetalle(var d: detalle; var archivoTxt:Text);
var dLocalidad: datosLocalidad; nombre:string;
begin
  nombre := 'archivoDetalle';
  assign (d,nombre);
  rewrite (d);
  reset (archivoTxt);
  while (not eof (archivoTxt)) do begin
    readln(archivoTxt, dLocalidad.nombreProvincia, dLocalidad.codigoLocalidad, dLocalidad.cantAlfabetizados, dLocalidad.cantEncuestados);
    write(d,dLocalidad);
  end;
  close (archivoTxt);
  close (d);
end;

procedure leerDetalle (var archivo: detalle; var dato: datosLocalidad);
begin
  if (not (eof (archivo))) then read(archivo, dato)
  else dato.codigoLocalidad := valor_alto;
end;

procedure minimo (var det1, det2: detalle; var r1,r2,min: datosLocalidad);
begin
  if(r1.codigoLocalidad <= r2.codigoLocalidad) then begin
    min:= r1;
    leerDetalle(det1,r1);
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
 
var d1,d2:detalle; m:maestro; archivoTxt:Text; nombre:string; 

begin

    writeln('Ingrese el nombre del archivo maestro .txt');
    readln(nombre);
    assign(archivoTxt, nombre);
    reset(archivoTxt);
    crearMaestro(m, archivoTxt);
    writeln('Archivo maestro creado correctamente.');

    writeln('Ingrese el nombre del archivo detalle 1 .txt');
    readln(nombre);
    assign(archivoTxt, nombre);
    reset(archivoTxt);
    crearDetalle(d1, archivoTxt);
    writeln('Archivo detalle 1 creado correctamente.');

    writeln('Ingrese el nombre del archivo detalle 2 .txt');
    readln(nombre);
    assign(archivoTxt, nombre);
    reset(archivoTxt);
    crearDetalle(d2, archivoTxt);
    writeln('Archivo detalle 2 creado correctamente.');

    actualizarMaestro(m, d1, d2);

end.
