unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, variablesH, newtonGeneralizado;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    button2: TButton;
    Button3: TButton;
    inputVersion: TComboBox;
    inputError: TEdit;
    inputFuncion: TEdit;
    inputValorVariable: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    labelAgregarVariable: TLabel;
    StringGrid1: TStringGrid;
    procedure agregarFuncion(Sender: TObject);
    procedure agregarVariable(Sender: TObject);
    procedure ejecutar(Sender: TObject);
    procedure OnCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.agregarVariable(Sender: TObject);
begin
  setLength(values, length(values)+1, 1);
  values[length(values)-1, 0]:= StrToFloat(inputValorVariable.Text);
  labelAgregarVariable.Caption:= 'valor x' + IntToStr(length(values));
end;

procedure TForm1.agregarFuncion(Sender: TObject);
begin

  setLength(functionArray, length(functionArray)+1);
  functionArray[length(functionArray)-1]:= inputFuncion.text;
  showMessage('funcion agregada');

end;

procedure TForm1.ejecutar(Sender: TObject);
var
  algoritmoNewton: CNewtonGeneral;
  i: Integer;
begin
  algoritmoNewton:= CNewtonGeneral.create;
  algoritmoNewton.version:= inputVersion.ItemIndex;
  
  algoritmoNewton.allowedError:= StrToFloat(inputError.text);
  algoritmoNewton.execute;

  with StringGrid1 do begin
    RowCount:= algoritmoNewton.sequence.Count;
    cols[1].Assign(algoritmoNewton.sequence);
    cols[2].Assign(AlgoritmoNewton.errorEstimado);

    for i:=1 to RowCount-1 do
      Cells[0,i]:= IntToStr(i);

  end;

  setLength(values,0,0);
  setLength(functionArray, 0);
  labelAgregarVariable.Caption:= 'valor x0';


end;

procedure TForm1.OnCreate(Sender: TObject);
var
  versiones: TstringList;
begin
  versiones:= TStringList.create;
  versiones.AddObject('sin aproximacion', TObject(isSinAprox));
  versiones.AddObject('con aproximacion', TObject(isConAprox));
  setLength(values,0,0);
  setLength(functionArray, 0);
  inputVersion.Items.Assign(versiones);
end;

end.
