unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Spin,
  StdCtrls, algebraMatrices, variablesH;

type

  { TForm1 }

  TForm1 = class(TForm)
    agregarValorButton: TButton;
    calcButton: TButton;
    colsMatrix1: TSpinEdit;
    colsMatrix2: TSpinEdit;
    InputValorVariable: TEdit;
    labelValorVariable: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    resultadoNumerico: TEdit;
    operaciones: TComboBox;
    parametroExtra: TEdit;
    rowsMatrix1: TSpinEdit;
    rowsMatrix2: TSpinEdit;
    matrixA: TStringGrid;
    matrixB: TStringGrid;
    resultadoGrid: TStringGrid;
    procedure agregarValorButtonClick(Sender: TObject);
    procedure calcular(Sender: TObject);
    procedure colsMatrix1Change(Sender: TObject);
    procedure colsMatrix2Change(Sender: TObject);
    procedure OnCreate(Sender: TObject);
    procedure rowsMatrix1Change(Sender: TObject);
    procedure rowsMatrix2Change(Sender: TObject);
    procedure fillMatrix(m: twoDimensionArr; isA: Boolean);
    procedure fillResultMatrix;
    procedure fillFunctionArray;
  private
    algMatrices: MatrixAlgebra;

  public

  end;

var
  Form1: TForm1;


implementation

var
  i,j: Integer;

{$R *.lfm}

{ TForm1 }

procedure TForm1.fillFunctionArray;
begin
  setLength(functionArray, matrixA.rowCount);
  for i:=0 to MatrixA.rowCount -1 do
    functionArray[i]:= matrixA.Cells[0,i];
end;
procedure TForm1.fillResultMatrix;
begin
  resultadoGrid.clear;
  resultadoGrid.RowCount:= filasRes;
  resultadoGrid.ColCount:= colsRes;
  for i:=0 to filasRes-1 do
    for j:=0 to colsRes-1 do
      resultadoGrid.Cells[j,i] := FloatToStr(resultado[i,j]);
end;

procedure TForm1.fillMatrix(m: twoDimensionArr; isA: Boolean);
begin

  for i:=0 to Length(m)-1 do
    for j:=0 to Length(m[0])-1 do
      if isA then
        m[i,j] := StrToFloat(matrixA.Cells[j,i])
      else
        m[i,j] := StrToFloat(matrixB.Cells[j,i]);


end;

procedure TForm1.colsMatrix1Change(Sender: TObject);
begin
  matrixA.clear;
  matrixA.colCount:= colsMatrix1.Value;
end;

procedure TForm1.calcular(Sender: TObject);
begin
  operacionIndex:= operaciones.ItemIndex;
  if operacionIndex <> 9 then begin
     filasA:= rowsMatrix1.Value;
     columnasA:= colsMatrix1.Value;
     SetLength(A, filasA, columnasA);
     fillMatrix(A, True);
     escalar:= StrToFloat(parametroExtra.Text);
  end
  else
  begin
    fillFunctionArray;
  end;

  if (operacionIndex > 9)  and (operacionIndex < 14)then begin
    filasB:= rowsMatrix2.Value;
    columnasB:= colsMatrix2.Value;
    SetLength(B, filasB, columnasB);
    fillMatrix(B, False);
  end;
  algMatrices.ejecutar;
  if (operaciones.ItemIndex = 8) or (operaciones.ItemIndex = 14) then
    resultadoNumerico.Text:= FloatToStr(resultadoEscalar);
  filasRes:= length(resultado);
  colsRes:= length(resultado[0]);
  fillResultMatrix;
  labelValorVariable.Caption:= 'agregar variable x_0 con valor: ';
  countVariables:=0;
  SetLength(values, 0);
end;

procedure TForm1.agregarValorButtonClick(Sender: TObject);
begin
  SetLength(values, length(values) +1);
  values[length(values)-1] := StrToFloat(InputValorVariable.Text);
  countVariables:= countVariables+1;
  ShowMessage(IntToStr(length(values)-1) + LineEnding + FloatToStr(values[length(values)-1]));
  labelValorVariable.Caption := 'agregar variable x'+ IntToStr(countVariables) + ' con valor: ';
end;

procedure TForm1.colsMatrix2Change(Sender: TObject);
begin
  matrixB.clear;
  matrixB.colCount:= colsMatrix2.Value;
end;

procedure TForm1.OnCreate(Sender: TObject);
begin
  setLength(values,0);
  algMatrices.create;
     matrixB.Options:= matrixB.Options + [goEditing];
     matrixA.Options:= matrixA.Options + [goEditing];
     operacionesList := TStringList.create;
     operacionesList.AddObject('Suma Escalar', TObject(isSumaEscalar));
     operacionesList.AddObject('Resta Escalar', TObject(isRestaEscalar));
     operacionesList.AddObject('potenciacion', TObject(isPotenciacion));
     operacionesList.AddObject('mult. escalar', TObject(isMultEscalar));
     operacionesList.AddObject('transpuesta', TObject(isTranspuesta));
     operacionesList.AddObject('inversa', TObject(isInversa));
     operacionesList.AddObject('adjunta', TObject(isAdjunta));
     operacionesList.AddObject('division', TObject(isDivision));
     operacionesList.AddOBject('determinante', TObject(isDeterminante));
     operacionesList.AddOBject('Jacobiana', TObject(isJacobiana));
     operacionesList.AddObject('Suma', TObject(isSuma));
     operacionesList.AddObject('Resta', TObject(isResta));
     operacionesList.AddObject('multiplicacion', TObject(isMult));
     operacionesList.AddObject('division binaria', TObject(isDivisionBinaria));
     operacionesList.AddObject('traza', TObject(isTraza));
     operacionesList.AddObject('triangularizacion', TObject(isMatrizTriangular));
     operaciones.Items.Assign(operacionesList);
     matrixA.clear;
     matrixA.rowCount:= rowsMatrix1.Value;
     matrixA.colCount:= colsMatrix1.Value;;
     matrixB.clear;
     matrixB.rowCount:= rowsMatrix2.Value;
     matrixB.colCount:= colsMatrix2.Value;

end;

procedure TForm1.rowsMatrix1Change(Sender: TObject);
begin
  matrixA.clear;
  matrixA.RowCount:= rowsMatrix1.Value;

end;

procedure TForm1.rowsMatrix2Change(Sender: TObject);
begin
  matrixB.clear;
  matrixB.RowCount:= rowsMatrix2.Value;

end;

end.
