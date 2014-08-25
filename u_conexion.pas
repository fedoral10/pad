unit u_Conexion;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
   cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, sqldb, DB, sqlite3conn, Forms, Dialogs, LCLType;

type
  TConexion = class(TObject)
  private
    omDataSource: TDataSource;
    //omGrid: TDBGrid;
    omConn: TSQLite3Connection;
    omSQLQuery: TSQLQuery;
    omTransaccion: TSQLTransaction;
    function ArmarConsulta(columnas: array of string; tabla: string;
      wheres: array of string; OrderBy: string = ''): string;
  public
    procedure InicializaConexion;
    function EjecutaConsulta(sql: string): TDataSource;
    function Buscar(Primer_Nombre, Segundo_Nombre, Primer_Apellido,
      Segundo_Apellido, Cedula: string): TDataSource;
  end;

implementation

procedure TConexion.InicializaConexion;
begin
  try
    self.omTransaccion := TSQLTransaction.Create(nil);
    self.omConn := TSQLite3Connection.Create(nil);
    self.omDataSource := TDataSource.Create(nil);
    self.omSQLQuery := TSQLQuery.Create(nil);

    //self.omConn.DatabaseName := 'C:\Users\jorge.potosme\pad\pad.db';
    self.omConn.DatabaseName := 'C:\SQLite\pad.db';
    self.omConn.Transaction := Self.omTransaccion;
    self.omSQLQuery.DataBase := Self.omConn;
    self.omSQLQuery.Transaction := Self.omTransaccion;
    self.omDataSource.DataSet := self.omSQLQuery;
  except
    on E: Exception do
      Application.MessageBox(PChar('Ha ocurrido el siguiente error: ' +
        E.Message), 'ERROR', MB_OK + MB_ICONERROR);
  end;
end;

function TConexion.EjecutaConsulta(sql: string): TDataSource;
begin
  try
  self.omSQLQuery.SQL.Add(sql);
  self.omSQLQuery.Active := True;
  Result := omDataSource;
  except
    on E: Exception do
    Application.MessageBox(PChar('Ha ocurrido el siguiente error: ' +
        E.Message), 'ERROR', MB_OK + MB_ICONERROR);
  end;
end;

function TConexion.ArmarConsulta(columnas: array of string; tabla: string;
  wheres: array of string; OrderBy: string = ''): string;
var
  sql: string;
  cantidad_where: integer;
  i: integer;
begin
{
Comienza la estructura del select
}
  cantidad_where := Length(wheres);
  //Agrega la palabra select
  sql := 'SELECT ';
  //Agrega las columnas a sql
  for i := low(columnas) to high(columnas) do
  begin
    sql := sql + ' ' + columnas[i] + ' ';
    if i <> high(columnas) then
    begin
      sql := sql + ' , ';
    end;
  end;
  //Agrega la palabra reservada FROM y el nombre de la tabla
  sql := sql + ' FROM ' + tabla;
  //Agrega la palabra reservada WHERE
  if cantidad_where > 0 then
  begin
    sql := sql + ' WHERE ';
    //Agrega los wheres
    for i := Low(wheres) to high(wheres) do
    begin
      sql := sql + wheres[i];
      if i <> high(wheres) then
      begin
        sql := sql + ' AND ';
      end;
    end;
  end;

  //Agrega el orderby si existe
  if OrderBy <> '' then
  begin
    sql := sql + ' ORDER BY ' + OrderBy;
  end;
  //regresa el sql armado
  Result := sql;
end;

function TConexion.Buscar(primer_nombre, segundo_nombre, primer_apellido,
  segundo_apellido, cedula: string): TDatasource;
var
  consulta: string;
  columnas: array [1..5] of string;
  wheres: array of string;
begin
  columnas[1] := 'primer_nombre';
  columnas[2] := 'segundo_nombre';
  columnas[3] := 'primer_apellido';
  columnas[4] := 'segundo_apellido';
  columnas[5] := 'cedula';

  SetLength(wheres,4);
  wheres[0] := ' primer_nombre like ' + QuotedStr('%' + Primer_Nombre + '%');
  wheres[1] := ' segundo_nombre like ' + QuotedStr('%' + Segundo_Nombre + '%');
  wheres[2] := ' primer_apellido like ' + QuotedStr('%' + Primer_Apellido + '%');
  wheres[3] := ' segundo_apellido like ' + QuotedStr('%' + Segundo_Apellido + '%');
  if(cedula<>'')then
  begin
    SetLength(wheres, 5);
    wheres[4] := ' cedula = ' + QuotedStr('%' + cedula + '%');
  end;
  consulta := self.ArmarConsulta(columnas, 'padron', wheres);

  //ShowMessage(consulta);
  writeln(consulta);
  Result := self.EjecutaConsulta(consulta);
  //where := where + ' primer_nombre like ' + QuotedStr('%' + Primer_Nombre + '%');
end;

end.
