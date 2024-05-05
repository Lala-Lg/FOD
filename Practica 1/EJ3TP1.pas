program EJ3TP1;
type 
  Cadena=string[20];
  empleado=record
    numero:integer;
    apellido:cadena;
    nombre:cadena;
    edad:integer;
    dni:integer;
  end;
  archivo=file of empleado;
  procedure leerDatos(var Emp:empleado);
  begin
    writeln('Apellido: ');
    readln(emp.apellido);
    if(emp.apellido<>'fin')then begin
      writeln('Numero de empleado: ');
      readln(emp.numero);
      writeln('Edad: ');
      readln(emp.edad);
      writeln('DNI: ');
      readln(emp.dni);
      writeln('Nombre: ');
      readln(emp.nombre);
    end;
  end;
  
  procedure crearArchivo (var a:archivo);
  var nombre: cadena;
  begin
    writeln('Ingrese el nombre del archivo');
    readln(nombre);
    assign(a,nombre);
  end;
  
  procedure escribirArchivo(var a:archivo);
  var
    emp:empleado;
  begin
    rewrite(a);
    leerDatos(emp);
    while(emp.apellido<>'fin')do begin
      write(a, emp);
      leerDatos(emp)
    end;
    close(a);
  end;
  
  procedure leerEmpleado(e:empleado);
  begin
    writeln(e.numero);
    writeln(e.nombre);
    writeln(e.apellido);
    writeln(e.dni);
    writeln(e.edad);
  end;
  
  procedure opcion1 (var a:archivo);
  var 
    nomape:cadena;
    e:empleado;
  begin
    writeln('Ingrese nombre o apellido a buscar:');
    readln(nomape);
    reset(a);
    while(not eof(a)) do begin
      read(a,e);
      if (e.nombre=nomape)or(e.apellido=nomape) then
		leerEmpleado(e);
	end;
    close(a);
  end;
  
  procedure opcion3 (var a:archivo);
  var 
    e:empleado;
  begin
    reset(a);
    while(not eof(a)) do begin
      read(a,e);
      if (e.edad>70) then
		leerEmpleado(e);
	end;
    close(a);
  end; 
  
  procedure opcion2(var a:archivo);
  var e:empleado;
  begin
    reset(a);
    while not eof(a)do begin
      read(a,e);
      leerEmpleado(e);
    end;
    close(a);
  end;

procedure menu(var a:archivo);
var
  aux:integer;
begin
  aux:=4;
  writeln('HOLA BIENVENIDO AL MENU,INGRESE 1,2,3 O 0 PARA FINALIZAR');
  while(aux<>0)do begin
   readln(aux);
   case aux of
    1:opcion1(a);
    2:opcion2(a);
    3:opcion3(a);
   end;
  end;
end;
var
 a:archivo;
begin
  crearArchivo(a);
  escribirArchivo(a);
  menu(a);
end.
