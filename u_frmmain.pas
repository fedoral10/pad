unit u_FrmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, u_Conexion;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    Button1: TButton;
    DBGrid1: TDBGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Conexion: TConexion;
    { private declarations }
  public
    { public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.Button1Click(Sender: TObject);
begin

  Conexion.InicializaConexion;
  DBGrid1.DataSource:=Conexion.EjecutaConsulta('select * from municipio');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Conexion:=TConexion.create;
end;

end.

