program EJ4P1;
type 
  cadena=string[20];
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
  
  function buscarNumero(var a:archivo; n:integer):boolean;
  var e:empleado;
  begin
    read(a,e);
    while ((not EOF(a)) AND (e.numero <> n)) do begin
      read(a,e);
    end;
    buscarNumero := (e.numero = n);
  end;
  
  procedure opcion4(var a:archivo);
  var e:empleado;
  begin   
    reset(a);
    leerDatos(e);
    while(e.apellido<>'fin')do begin
    //EOF(a) es una funcion que devuelve un booleano, no se puede usar en seek para ubicarse al final del archivo.
      //Util para agregar nuevos registros al final del archivo.
      seek(a,fileSize(a));
      if(buscarNumero(a,e.numero)) then write(a, e)
      else writeln('El numero del empleado nuevo ya le pertenece a alguien mas');
      leerDatos(e);
    end;
    close(a);   
  end;
  
  procedure modificarEdad(var a:archivo);
  var 
    nomape:cadena;
    e:empleado;
  begin
    writeln('Ingrese nombre o apellido a buscar:');
    readln(nomape);
    reset(a);
    while(not eof(a)) do begin
      read(a,e);
      if ((e.nombre=nomape)or(e.apellido=nomape)) then begin
      seek(a,filePos(a)-1);
      //Sobreescribo la variable que deseo modificar.
      readln(e.edad);
      write(a,e);
      end
      else writeln('No existe la persona en el archivo');
	end;
    close(a);
  end;
  
  procedure exportar(var te:text; var a:archivo);
  var e:empleado;
  begin
    assign(te,'todos_empleados.txt');
    reset(a);
    rewrite(te);
    while not eof(a)do begin
      read(a,e);
      with e do writeln(te, numero,apellido,nombre,edad,dni);
    end;
    //No hace falta aÃ±adir en la ultima posicion nuevamente
    close(a);
    close(te);
 end;

  procedure exportarDeNuevo(var te:text; var a:archivo);
  var e:empleado;
  begin
    assign(te,'faltaDNIEmpleado.txt');
    reset(a);
    rewrite(te);
    while not eof(a)do begin
      read(a,e);
      if(e.dni<>0)then with e do writeln(te, numero,apellido,nombre,edad,dni);
    end;
    close(a);
    close(te);
 end;

procedure menu(var a:archivo);
var
  aux:integer;
  te:text;
begin
  aux:=4;
  writeln('HOLA BIENVENIDO AL MENU,INGRESE 1,2,3 O 0 PARA FINALIZAR');
  while(aux<>0)do begin
   readln(aux);
   case aux of
    1:opcion1(a);
    2:opcion2(a);
    3:opcion3(a);
    4:opcion4(a);
    5:modificarEdad(a);
    6:exportar(te,a);
    7:exportarDeNuevo(te,a);
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

