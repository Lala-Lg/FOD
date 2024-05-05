program EJ7P1.pas;
type 
  str=string[30];
  novela=record
  codigoNovela:integer;
  nombreNovela:str;
  genero:str;
  precio:real;
  end;
  archivoBinario=file of novela;

//Nombrar el archivo binario
  procedure nombrarArchivo (var novelas:archivoBinario);
  var nombre: cadena;
  begin
    writeln('Ingrese el nombre del archivo');
    readln(nombre);
    Assign(novelas,nombre);
  end;
  
//Cargar archivo binario con el archivo de texto  
procedure cargarBinario(var novelas:archivoBinario; var archivoTxt:Text);
var n:novela;
begin
  nombrarArchivo(novelas);
  Rewrite(novelas); //Creo el archivo.
  Assing(archivoTxt,'novelas.txt'); //indico cual es el archivo con el que trabajaré
  Reset(archivoTxt); //Lo abro
  //Mientras no termine el archivo de texto, cargo el archivo binario
  while (not Eof(txt)) do begin
  //El enunciado dice que los datos de c/ novela se almacenan en dos líneas.
    readLn(archivoTxt,n.codigoNovela,n.genero,n.precio);
    readLn(archivoTxt,n.nombreNovela);
    write(novela,n); //Escribo en el archivo binario el registro de la novela.
    end;
  //Importante, siempre cerrar los archivos.
  close(novelas);
  close(archivoTxt);
end;

//Abrir el archivo binario y permitir la actualización del mismo.
procedure leerNovela(var n:novela);
begin
  writeln('Datos de la novela: ');
  with n do begin
  writeln('Código: ');
  readln(codigoNovela);
  writeln('Género: ');
  readln(genero);
  writeln('Precio: ');
  readln(precio);
  writeln('Nombre: ');
  readln(nombreNovela);
  end;
end;

procedure agregarNovela(var novelas:archivoBinario);
var n:novela;
begin
  reset(novelas); //Abro el archivo.
  leerNovela(n);
  seek(novelas,FileSize(novelas)); //Busco la última posición para agregar la novela.
  write(novelas,n); //Escribo la novela en el archivo.
  close(novelas); //Cierro el archivo.
end;

//Modificar una existente. Las búsquedas se realizan porcódigo de novela.
procedure modificarExistente(var novelas:archivoBinario);
var
  n:novela;
  codigoBusqueda:integer;
  encontre:boolean;
  
  begin
  reset(novelas);
  writeln('Ingrese codigo de la novela que quiere modificar: ');
  readln(codigoBusqueda);
  encontre:=false;
  while(not (Eof(novelas)) and not (encontre)) do begin
     readln(novelas,n);//Leo y avanzo;
     encontre= (n.codigoNovela = codigoNuevo);
  end;
  if (encontre) then begin
    writeln('La novela que busca existe, ingrese los datos para modificarla');
    leerNovela(n);
    seek(novelas,FilePos(novelas)-1); //Guardo la novela en la posición anterior en la que el readln dejó el puntero.
    write(novelas,n);
  end
  else writeln('La novela que busca NO existe');
  Close(novelas);//Ciero el archivo.
end;

procedure menu(var novelas:archivoBinario);
var opcion:integer;
begin
  opcion:=1;
  while(opcion>0 and opcion<3) do begin
    writeln('Menu');
    writeln('Ingrese 1 en el teclado numérico si desea agregar una novela');
    writeln('Ingrese 2 en el teclado numérico si desea modificar una novela');
    writeln('Ingrese cualquier otro número si desea salir');
    read(opcion);
    case opcion of
      1:agregarNovela(novelas);
      2:modificarExistente(novelas);
    end;
  end; 
end;

var novelas:archivoBinario; archivoTxt:Text;
begin
  cargarBinario(novelas,archivoTxt);
  menu(novelas);
end;
  
