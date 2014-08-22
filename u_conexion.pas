unit u_Conexion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, sqlite3conn, Forms, Dialogs, LCLType;

type
  TConexion = class(TObject)
  private
    omDataSource: TDataSource;
    //omGrid: TDBGrid;
    omConn: TSQLite3Connection;
    omSQLQuery: TSQLQuery;
    omTransaccion: TSQLTransaction;
  public
    procedure InicializaConexion;
    function EjecutaConsulta(sql: string): TDataSource;
  end;

implementation

procedure TConexion.InicializaConexion;
begin
  try
    self.omTransaccion := TSQLTransaction.Create(nil);
    self.omConn := TSQLite3Connection.Create(nil);
    self.omDataSource := TDataSource.Create(nil);
    self.omSQLQuery := TSQLQuery.Create(nil);

    self.omConn.DatabaseName := 'C:\Users\jorge.potosme\pad\pad.db';
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
  self.omSQLQuery.SQL.Add(sql);
  self.omSQLQuery.Active := True;

  Result := omDataSource;
end;

end.
