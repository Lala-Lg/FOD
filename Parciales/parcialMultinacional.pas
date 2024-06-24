program parcialMultinacional;
const valorAlto = 999;
type
  empleado = record 
  dni:integer;
  nombre:string;
  apellido:string;
  edad:integer;
  domicilio:string;
  fecha:string;
  end;
  maestro = file of empleado;
  
procedure leer (var m:maestro; var dato:empleado);
begin
  if (not eof(m)) then read(m,dato)
  else dato.dni := valorAlto;
end;

function existeEmpleado(var m:maestro; dni:integer):boolean;
var e:empleado; existe:boolean;
begin
  reset(m);
  leer(m,e);
  existe:=false;
  while (e.dni <> valorAlto) and (not existe) do begin
     if e.dni = dni then existe:=true else leer(m,e);
  end;
  existeEmpleado:=existe;
  close (m);
end;
procedure nuevoEmpleado (var e:empleado);
begin
  readln(e.dni);
  readln(e.nombre);
  readln(e.apellido);
  readln(e.edad);
  readln(e.domicilio);
  readln(e.fecha);
end;

{Agregar empleado: solicita al usuario que ingrese los datos del empleado y lo agrega al archivo sólo si el dni ingresado no existe. 
Suponga que existe una función llamada existeEmpleado que recibe un dni y un archivo 
y devuelve verdadero si el dni existe en el archivo o falso en caso contrario. 
La función existeEmpleado no debe implementarla. Si el empleado ya existe, debe informarlo en pantalla.}

procedure altaEmpleado(var m:maestro; var e:empleado);
var aux:empleado;
begin
  reset(m);
  read(m,aux);
  if (existeEmpleado(m,e.dni)) then begin //Si ya existe el empleado...
    writeln('El empleado con DNI ', e.dni, ' ya existe en el archivo.');
  end
  else begin //Si no existe me fijo si hay lugar entre medio para agregarlo.
       reset(m);
       read(m,aux);
       if (aux.dni <> 0)then begin
       seek(m,aux.dni*(-1));
       read(m,aux); //Me guardo el nuevo "indice" en aux.
       seek(m,filepos(m)-1); //Como leí y me corrí de posición vuelvo hacia atrás.
       write(m,e); //Agrego la nueva distribución en el espacio que encontré.
       seek(m,0); //vuelvo al inicio
       write(m,aux); //reescribo nueva cabecera
       end
       else begin
       seek(m,fileSize(m)); //Sino lo agrego al final del archivo.
       write(m,e);
       end;
       close(m);
       end;
end;

procedure bajaEmpleado(var m:maestro);
var
    dni:integer;
    cabecera,aux:empleado;
begin
    writeln('Ingrese dni del empleado a eliminar.');
    readln(dni);
    if (existeEmpleado(m,dni)) then begin
      reset(m);
      read(m,cabecera); //El primero registro del archivo es el que guarda el registro de cabecera que contiene el indice del último elemento borrado.
      read(m,aux);//Aux recorre en busqueda.
      while (dni<>aux.dni) do read(m,aux); //Busco el empleado en el archivo para eliminarlo.
      aux.dni:=(filepos(m)-1 * (-1)); 
      seek(m,filePos(m)-1);
      write (m,cabecera);  
      seek(m,0);   
      write(m,aux); 
      close(m);
    end
    else writeLn('El empleado no existe.');
end; 

var m:maestro; dato:empleado; 
begin
    assign(m,'maestro.bin');
    writeln('Ingrese nuevo empleado para analizar');
    nuevoEmpleado(dato);
    altaEmpleado(m,dato);
    bajaEmpleado(m);
end.
