unit u_FrmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, u_Conexion;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnBuscar: TButton;
    DBGrid1: TDBGrid;
    lblCedula: TLabel;
    lblSegNombre: TLabel;
    lblPriApellido: TLabel;
    lblSegApellido: TLabel;
    txtPriNombre: TEdit;
    lblNombre: TLabel;
    txtCedula: TEdit;
    txtSegNombre: TEdit;
    txtPriApellido: TEdit;
    txtSegApellido: TEdit;
    procedure btnBuscarClick(Sender: TObject);
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

procedure TfrmMain.btnBuscarClick(Sender: TObject);
begin

  Conexion.InicializaConexion;
  //DBGrid1.DataSource:=Conexion.EjecutaConsulta('select * from municipio');
  DBGrid1.DataSource:=conexion.Buscar(txtPriNombre.Text,txtSegNombre.Text,txtPriApellido.Text,txtSegApellido.Text,txtCedula.Text);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Conexion:=TConexion.create;
end;

end.

