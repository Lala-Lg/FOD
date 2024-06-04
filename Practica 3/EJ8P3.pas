{
Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.

}
program EJ8P3;
const valorAlto = 'ZZZ';
type 
  distribucion = record
    nombre:string[20];
    anioL:integer;
    versionKernel:string[20];
    cantDesarrolladores:integer;
    descripcion:string[50];
    end;
    maestro = file of distribucion;
//El archivo se dispone.
{El nombre de las distribuciones no puede repetirse.}

{Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.}

{ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.}
procedure leer (var m:maestro; var dato:distribucion);
begin
  if (not eof(m)) then read(m,dato)
  else dato.nombre := valorAlto;
end;
function existeDistribucion (var m:maestro; nombre:string):boolean;
var d:distribucion; existe:boolean;
begin
  reset(m);
  leer(m,d);
  existe:=false;
  while (d.nombre <> valorAlto) and (not existe) do begin
     if d.nombre = nombre then existe:=true else leer(m,d);
  end;
  existeDistribucion:=existe;
  close (m);
end;
procedure nuevaDistribucion (var dato:distribucion);
begin
    writeLn('Ingrese nombre, año lanzamiento, num del kernel, cantidad desarrolladores y descripción.');
    readln(dato.nombre);
    readln(dato.anioL);
    readln(dato.versionKernel);
    readln(dato.cantDesarrolladores);
    readln(dato.descripcion);
end;

{AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.}

procedure altaDistribucion (var m:maestro; var dato:distribucion);
var aux:distribucion;
begin
  reset(m);
  read(m,aux); //El primero que leo es aquel que
  {Para marcar una distribución como borrada se debe utilizar el campo cantidad de desarrolladores} 
  if (aux.cantDesarrolladores <> 0) then begin //Si hay espacio entonces
    seek(m,aux.cantDesarrolladores*(-1));
    read(m,aux); //Me guardo el nuevo "indice" en aux.
    seek(m,filepos(m)-1); //Como leí y me corrí de posición vuelvo hacia atrás.
    write(m,dato); //Agrego la nueva distribución en el espacio que encontré.
    seek(m,0); //vuelvo al inicio
    write(m,aux); //reescribo nueva cabecera
  end
  else begin
       seek(m,fileSize(m)); //Sino lo agrego al final del archivo.
       write(m,dato);
       end;
  close(m);
end;

{BajaDistribución: módulo que da de baja lógicamente una distribución
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.}

procedure bajaDistribucion(var m:maestro);
var
    nombre:string;
    cabecera,aux:distribucion;
begin
    writeln('Ingrese nombre de la distribucion a eliminar.');
    readln(nombre);
    reset(m);
    read(m,cabecera); //El primero registro del archivo es el que guarda el registro de cabecera que contiene el indice del último elemento borrado.
    if (existeDistribucion(m,nombre)) then begin
      read(m,aux);
      while (nombre<>aux.nombre) do read(m,aux);
      aux.cantDesarrolladores:=(filepos(m)-1 * (-1)); 
      seek(m,filePos(m)-1);
      write (m,cabecera);  
      seek(m,0);   
      write(m,aux); 
    end
    else 
        writeLn('Distribución no existente.');
    close(m);
end; 
var m:maestro; dato:distribucion; 
begin
    //Falta leer el dato nuevo para dar de alta.

    AltaDistribucion(m,dato);

    BajaDistribucion(m);
end.

