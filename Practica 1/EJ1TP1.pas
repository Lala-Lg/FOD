program EJ1TP1;
type 
  numerosEnteros = file of integer;
var 
  archivoEnteros : numerosEnteros;
  nombre: string;
  numero: integer;
begin
  //El nombre del archivo se solicita al usuario desde el teclado.
  writeln('Ingrese el nombre del archivo que desea crear');
  readln(nombre);
  
  //Creando el archivo
  assign (archivoEnteros,nombre);
  rewrite(archivoEnteros);
  
  //Recibo numeros desde teclado e incorporo hasta que ingrese el numero 3000
  //El 3000 no se escribe en el archivo.
  repeat
    writeln('Ingrese un numero (ingrese 3000 para finalizar):');
    readln(numero);
    
    if (numero <> 3000) then write (archivoEnteros, numero);
  until (numero = 3000);
  
  //Cierro el archivo, importante.
  close(archivoEnteros);
  
  writeln('El programa terminó, el archivo se creó exitosamente');
end.
