unit operacionesUnarias;

{$mode objfpc}{$H+}
interface

 uses
     Classes, SysUtils, Graphics,
     FileUtil, Forms, Controls, ExtCtrls,  Grids, Math, variablesH, operacionesBinarias, ParseMath;
     type  arrayReal = array of Real;
     type twoDimensionArr= array of arrayReal;
 type opUnarias = class
      procedure ejecutar(A: twoDimensionArr; AA: TStringGrid);
    private


    function getDeterminante(m: twoDimensionArr): Real;
    function getArrWithoutRowCol(m: twoDimensionArr; rr,cc: Integer) : twoDimensionArr;
    function sumaEscalar(A: twoDimensionArr): twoDimensionArr;
    function restaEscalar(A: twoDimensionArr): twoDimensionArr;
    function potenciacion(A: twoDimensionArr): twoDimensionArr;
    function multEscalar(A: twoDimensionArr): twoDimensionArr;
    function transpuesta(A: twoDimensionArr): twoDimensionArr;
    function inversa(A: twoDimensionArr): twoDimensionArr;
    function adjunta(A: twoDimensionArr): twoDimensionArr;
    function dividir(A: twoDimensionArr): twoDimensionArr;
    function jacobiana(A: TStringGrid): twoDimensionArr;
    procedure determinante(A: twoDimensionArr);


    public
      constructor Create();

  end;
const
  isSumaEscalar = 0;
  isRestaEscalar = 1;
  isPotenciacion = 2;
  isMultEscalar = 3;
  isTranspuesta = 4;
  isInversa = 5;
  isAdjunta = 6;
  isDivision = 7;
  isDeterminante = 8;
  isJacobiana = 9;
  h = 0.0001;
var
  r: Real;
implementation

var
  oBinaria:operacionesBin;

constructor opUnarias.create;
begin
  oBinaria.create();
end;


function opUnarias.jacobiana(a: TStringGrid): twoDimensionArr;
var
  i, j: Integer;
  parser: TParseMath;
begin
  parser:= TParseMath.create();
  for i:= 0  to length(values)-1 do
    parser.AddVariable('x'+ IntToStr(i), values[i]);
  SetLength(Result, a.RowCount, countVariables);
  for i:= 0 to a.RowCount -1 do
    parser.Expression:= a.Cells[1,i];
    for j:= 0 to countVariables -1 do begin
      Result[i,j]:= (-1)* parser.evaluate();
      //parser.NewValue('x' + IntToStr(j), values[j] + h);
      //result[i,j]:= (Result[i,j] + parser.evaluate) / h;
      //parser.NewValue('x'+ IntToStr(j), values[j]);
    end;
end;

function opUnarias.potenciacion(a:twoDimensionArr):twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result, length(a), Length(a[0]));
  if escalar = 0 then begin
    for i:=0 to length(a)-1 do
      for j:=0 to Length(a[0])-1 do
        if i = j then
          result[i,j] := 0
        else
          result[i,j] := 1;
  end;
  escalar:= escalar-1;

  for i := 0 to length(a) -1 do
    for j:= 0  to length(a[0]) -1 do
      result[i,j] :=a[i,j];

  while(escalar > 0) do begin
    result:= oBinaria.multiplicar(result, a);
    escalar:= escalar-1;
  end;

end;

function opUnarias.inversa(a:twoDimensionArr):twoDimensionArr;
begin
  escalar:=getDeterminante(a);
  a:=adjunta(a);
  a:=transpuesta(a);
  Result:= dividir(a);
end;

function opUnarias.adjunta(a:twoDimensionArr):twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result, length(a), length(a[0]));

  for i:=0 to Length(a)-1 do
    for j:=0 to Length(a[0])-1 do
      if ((i+j) mod 2 = 0) then
        result[i,j] :=  getDeterminante(getArrWithoutRowCol(a, i, j))
      else
        result[i,j] := getDeterminante(getArrWithoutRowCol(a,i,j)) *(-1);
end;

procedure opUnarias.determinante(a: twoDimensionArr);
begin
  r := getDeterminante(A);
end;

function opUnarias.getArrWithoutRowCol(m: twoDimensionArr; rr, cc: Integer): twoDimensionArr;
var
  actualRow,i,j, actualCol: Integer;
begin
  actualRow:= 0;
  actualCol:= 0;
  SetLength(Result, Length(m)-1 , Length(m)-1);
  for i:=0 to length(m)-1 do begin
    actualCol:=0;
    if i <> rr then begin
      for j := 0 to length(m)-1 do begin
        if j <> cc then begin
          Result[actualRow, actualCol]:= m[i,j];
          actualCol:= actualCol + 1;
        end;
      end;
      actualRow:= actualRow + 1;
    end;
  end;
end;

function opUnarias.getDeterminante(m: twoDimensionArr): Real;
var
  i:Integer;
begin
  Result:=0;
  if(length(m) = length(m[0])) then begin
    if (length(m) = 1) then
      Result:= m[0,0]
    else if (Length(m) = 2) then
      Result:= (m[0,0] * m[1,1]) - (m[0,1] * m[1,0])
    else
      for i:=0 to length(m)-1 do
        if i mod 2 = 0 then
          Result:= Result + m[0][i] * getDeterminante(getArrWithoutRowCol(m,0,i))
        else
          Result:= Result - m[0][i]* getDeterminante(getArrWithoutRowCol(m,0,i));
  end;
end;

procedure opUnarias.ejecutar(A: twoDimensionArr; AA: TStringGrid);
var
  i: Integer;
begin
  case operacionIndex of
    isSumaEscalar:
      begin
        Resultado := sumaEscalar(a);
      end;
    isRestaEscalar:
      begin
        Resultado := restaEscalar(a);
      end;
    isPotenciacion:
      begin
        Resultado := potenciacion(a);
      end;
    isMultEscalar:
      begin
        Resultado := multEscalar(a);
      end;
    isTranspuesta:
      begin
        Resultado := transpuesta(a);
      end;
    isInversa:
      begin
        Resultado := inversa(a);
      end;
    isAdjunta:
      begin
      Resultado := adjunta(a);
      end;
    isDivision:
      begin
        Resultado := dividir(a);
      end;
    isDeterminante:
      begin
        determinante(a);
      end;
    isJacobiana:
      begin
        resultado:= jacobiana(AA);
      end;
  end;
end;

function opUnarias.transpuesta(a: twoDimensionArr):twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result, Length(a), length(a[0]));
  for i:=0 to length(result)-1 do
    for j:=0 to length(result[0])-1 do
      result[i,j]:= A[j,i];

end;
function opUnarias.sumaEscalar(a: twoDimensionArr):twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result,  Length(a), length(a[0]));
  for i:=0 to length(result)-1 do
    for j:=0 to length(result[0])-1 do
      result[i,j]:= A[i,j]+Escalar;
end;

function opUnarias.restaEscalar(a: twoDimensionArr):twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result,  Length(a), length(a[0]));
  for i:=0 to length(result)-1 do
    for j:=0 to length(result[0])-1 do
      result[i,j]:= A[i,j]-Escalar;
end;

function opUnarias.multEscalar(a: twoDimensionArr): twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result,  Length(a), length(a[0]));
  for i:=0 to length(result)-1 do
    for j:=0 to length(result[0])-1 do
      result[i,j]:= A[i,j]*Escalar;
end;

function opUnarias.dividir(a: twoDimensionArr): twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result,  Length(a), length(a[0]));
  for i:=0 to length(a)-1 do
    for j:=0 to length(a[0])-1 do
      result[i,j]:= A[i,j]/Escalar;
end;


end.
