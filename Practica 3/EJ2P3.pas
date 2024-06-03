{
Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.
}
program ej2p3;
const valorAlto = 999;
type
    asistenteR = record
        nroAsistente:integer;
        apeNomb:string[20];
        email:string[15];
        tel:integer;
        dni:integer;
    end;
    archivo = file of asistenteR;

procedure cargar (var a:asistenteR);
begin
  WriteLn('Ingrese nroAsist, apellido y nombre, email, tel y dni, o 0 para salir');
  Readln(a.nroAsistente);
  if(a.nroAsistente<>0)then begin
    Readln(a.apeNomb);
    Readln(a.email);
    Readln(a.tel);
    Readln(a.dni);
  end;
end;

{generar un archivo con registros de longitud fija conteniendo información de asistentes
a un congreso a partir de la información obtenida por teclado.}
procedure generar(var a:archivo);
var
    asisR:asistenteR;
begin
    assign(a,'archivo_asistentes');
    Rewrite(a);
    cargar(asisR);
    while (asisR.nroAsistente<>0) do begin
        write(a,asisR);
        cargar(asisR);
    end;
    Close(a);
end;

procedure leerArchivo(var a:archivo; var asisR:asistenteR);
begin
if (not eof (a)) then
  read(a,asisR)
else
  asisR.nroAsistente := valorAlto;
end;

procedure bajaLogica (var a:archivo);
var asisR:asistenteR;
begin
  reset (a); //abro el archivo
  leerArchivo(a,asisR);
  while (asisR.nroAsistente <> valorAlto) do begin
    if(asisR.nroAsistente < 1000) then begin
      asisR.apeNomb := '@' + asisR.apeNomb;
      seek(a,filepos(a)-1);
      write(a,asisR); //Reescribo el nombre que pise en el registro que debe ser eliminado;
      end;
    leerArchivo(a,asisR);
  end;
  close (a); //Cierro el archivo
end;

procedure imprimirArchivo(var a: archivo);
var
    asisR: asistenteR;
begin
    reset(a);
    leerArchivo(a, asisR);
    while (asisR.nroAsistente <> valorAlto) do
    begin
        writeln('Nro Asistente: ', asisR.nroAsistente);
        writeln('Apellido y Nombre: ', asisR.apeNomb);
        writeln('Email: ', asisR.email);
        writeln('Tel: ', asisR.tel);
        writeln('DNI: ', asisR.dni);
        writeln('------------------------');
        leerArchivo(a, asisR);
    end;
    close(a);
end;

var a:archivo;
begin
  generar(a);
  writeln('Archivo sin eliminaciones');
  imprimirArchivo(a);
  bajaLogica(a);
  writeln('Archivo después de la baja lógica');
  imprimirArchivo(a);
end.
