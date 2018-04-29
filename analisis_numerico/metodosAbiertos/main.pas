unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, opmetodos;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    inputMultiplicity: TEdit;
    inputRespuesta: TEdit;
    inputFuncion: TEdit;
    inputError: TEdit;
    inputMetodo: TComboBox;
    inputX0: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    StringGrid1: TStringGrid;
    procedure ejecutarMetodo(Sender: TObject);
    procedure OnCreate(Sender: TObject);
    procedure verificarRespuesta(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ejecutarMetodo(Sender: TObject);
var
  met: OpenMethod;
  i: Integer;
begin
  met:= OpenMethod.create;
  met.parser.Expression:= inputFuncion.Text;
  met.xInit:= StrToFloat(inputX0.Text);
  met.multiplicity:= StrToInt(inputMultiplicity.Text);
  met.ErrorAllowed:= StrToFloat(inputError.Text);
  met.isMethod:= inputMetodo.itemIndex;
  inputRespuesta.Text:= FloatToStr(met.execute);
  with StringGrid1 do begin
    RowCount:=met.sequence.Count;
    cols[1].Assign(met.sequence);
    cols[2].Assign(met.errorEstimado);
    cells[0,0]:= 'iteracion';
    for i:= 1 to RowCount -1 do
      cells[0,i] := IntToStr(i-1);
  end;
end;

procedure TForm1.OnCreate(Sender: TObject);
var
  metodos: TStringList;
begin
  metodos:= TStringList.create;
  metodos.AddObject('Secante', TObject(isSecante));
  metodos.AddObject('Punto fijo', TObject(IsPuntoFijo));
  metodos.AddObject('Newton-Raphson', TObject(IsNewtonRaphson));
  metodos.AddObject('Newton-Raphson (2)', TObject(isNewtonRaphsonExtended));
  inputMetodo.Items.Assign(metodos);

end;

procedure TForm1.verificarRespuesta(Sender: TObject);
var
  met: OpenMethod;
  ans: Double;
begin
  met:= OpenMethod.create;
  met.parser.Expression:= inputFuncion.Text;
  ans:= met.test(StrToFloat(inputRespuesta.Text));
  showMessage('f('+ inputRespuesta.Text + ')= ' + FloatToStr(ans));

end;

end.
