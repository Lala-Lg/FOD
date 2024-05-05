program EJ2TP1;
type 
  numerosEnteros = file of integer;
var 
  archivoEnteros : numerosEnteros;
  nombre: string;
  numero: integer;
  totalNumerosMenores1500: integer;
  sumaNumeros: integer;
  promedio: real;
begin
  //El nombre del archivo se solicita al usuario desde el teclado.
  writeln('Ingrese el nombre del archivo que desea procesar');
  readln(nombre);
  
  // Abro el archivo para lectura.
  assign (archivoEnteros,nombre);
  reset (archivoEnteros);

  writeln('Contenido del archivo:');

  totalNumerosMenores1500 := 0;
  sumaNumeros := 0;

  while not eof(archivoEnteros) do
  begin

    read(archivoEnteros, numero);
    writeln(numero);

    if numero < 1500 then
    begin
      totalNumerosMenores1500 := totalNumerosMenores1500 + 1;
      sumaNumeros := sumaNumeros + numero;
    end;

  end;

  //Cierro el archivo, importante.
  close(archivoEnteros);

  //Puedo calcular el promedio cerrando el archivo primero, ya que no necesito más nada de él.

  if totalNumerosMenores1500 > 0 then
    promedio := sumaNumeros / totalNumerosMenores1500
  else
    promedio := 0;

  writeln('Cantidad de numeros menores a 1500: ', totalNumerosMenores1500);
  writeln('Promedio de los numeros ingresados: ', promedio:0:1);
  writeln('El programa termino, el archivo se creo exitosamente');
end.
