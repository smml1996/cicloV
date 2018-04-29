unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, algoritmoInterpolaciones;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    inputGradoPolinomio: TEdit;
    inputAgregarX: TEdit;
    inputAgregarY: TEdit;
    inputEvalX: TEdit;
    inputEvalY: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    StringGrid1: TStringGrid;
    procedure AgregarDato(Sender: TObject);
    procedure OnCreate(Sender: TObject);
    procedure predecir(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

var
  inter: interpolacion;

{$R *.lfm}

{ TForm1 }

procedure TForm1.predecir(Sender: TObject);
begin

  inter.GradoPolinomio := StrToInt(inputGradoPolinomio.Text);
  showMessage('f('+inputEvalX.Text+') = ' +FloatToStr(inter.predecir(StrtoFloat(inputEvalX.Text)))) ;

end;

procedure TForm1.AgregarDato(Sender: TObject);
var
  x,y: Double;
begin
    x:= StrToFloat(inputAgregarX.text);
    y:= StrToFloat(inputAgregarY.Text);
    inter.insertValues(x,y);

    inputAgregarX.Text := '';
    inputAgregarY.Text := '';

    StringGrid1.RowCount := StringGrid1.RowCount +1;

    StringGrid1.Cells[0, StringGrid1.RowCount-1] := IntToStr(StringGrid1.RowCount);
    StringGrid1.Cells[1, StringGrid1.RowCount-1] := FloatToStr(x);
    StringGrid1.Cells[2, StringGrid1.RowCount-1] := FloatToStr(y);
end;

procedure TForm1.OnCreate(Sender: TObject);
begin
  StringGrid1.RowCount :=1;

  inter:= interpolacion.create;
end;

end.
