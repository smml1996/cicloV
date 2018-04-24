unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ParseMath, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    buttonActualizarMinimo: TButton;
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Chart1FuncSeries1: TFuncSeries;
    Edit1: TEdit;
    inputXRecta: TEdit;
    inputYRecta: TEdit;
    inputXPunto: TEdit;
    inputXMax: TEdit;
    inputXmin: TEdit;
    inputFunction: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure actualizarXMax(Sender: TObject);
    procedure actualizarXMin(Sender: TObject);
    procedure addFunction(Sender: TObject);
    procedure agregarPunto(Sender: TObject);
    procedure agregarRectaHorizontal(Sender: TObject);
    procedure agregarRectaVertical(Sender: TObject);
    procedure calculateFunction(const AX: Double; out AY: Double);
    procedure OnCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation
var

parser: TParseMath;
{$R *.lfm}

{ TForm1 }

procedure TForm1.actualizarXMin(Sender: TObject);
begin
  Chart1.Extent.XMin:= StrToFloat(inputXMin.Text );
end;

procedure TForm1.addFunction(Sender: TObject);
begin
  Chart1FuncSeries1.Active:= false;
  parser.Expression:=inputFunction.Text;

  Chart1FuncSeries1.Active:= true;
end;

procedure TForm1.agregarPunto(Sender: TObject);
begin

end;

procedure TForm1.agregarRectaHorizontal(Sender: TObject);
begin

end;

procedure TForm1.agregarRectaVertical(Sender: TObject);
begin

end;

procedure TForm1.calculateFunction(const AX: Double; out AY: Double);
begin
  parser.NewValue('x', AX);
  AY:= parser.Evaluate();
end;

procedure TForm1.OnCreate(Sender: TObject);
begin
  Chart1.Extent.UseXMax:=true;
  Chart1.Extent.UseXMin:=true;
  Chart1FuncSeries1.Active:= false;
  Chart1.Proportional:= True;
  parser:= TParseMath.create();
  parser.AddVariable('x',0.0);
end;

procedure TForm1.actualizarXMax(Sender: TObject);
begin
  Chart1.Extent.XMax:= StrToFloat(inputXMax.Text);
end;

end.
