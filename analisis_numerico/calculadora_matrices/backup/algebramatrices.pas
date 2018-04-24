unit algebraMatrices;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, variablesH, ParseMath, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Spin,
  StdCtrls;
  type  arrayReal = array of Real;
  type twoDimensionArr= array of arrayReal;
  type doubleArr = array of Double;
  type MatrixAlgebra = class

      procedure ejecutar;
       private
       function divideVector(v: arrayReal; e: Real): arrayReal;
       function multiplyVector(v:arrayReal; e:Real): arrayReal;
       function restaVectores(v, w:arrayReal): arrayReal;
       function getDeterminante(m: twoDimensionArr): Real;
       function getArrWithoutRowCol(m: twoDimensionArr; rr,cc: Integer) : twoDimensionArr;
       function sumaEscalar(M: twoDimensionArr): twoDimensionArr;
       function restaEscalar(M: twoDimensionArr): twoDimensionArr;
       function potenciacion(M: twoDimensionArr): twoDimensionArr;
       function multEscalar(M: twoDimensionArr): twoDimensionArr;
       function transpuesta(M: twoDimensionArr): twoDimensionArr;
       function inversa(M: twoDimensionArr): twoDimensionArr;
       function adjunta(M: twoDimensionArr): twoDimensionArr;
       function dividirEscalar(M: twoDimensionArr): twoDimensionArr;
       function jacobiana(): twoDimensionArr;
       procedure determinante(M: twoDimensionArr);
       function suma(M,N:twoDimensionArr): twoDimensionArr;
       function resta(M,N:twoDimensionArr): twoDimensionArr;
       function multiplicar(M,N:twoDimensionArr): twoDimensionArr;
       function dividir(M,N: twoDimensionArr): twoDimensionArr;
       function getTraza(M: twoDimensionArr): Real;
       function matrizTriangular(M: twoDimensionArr): twoDimensionArr;
       procedure traza(M: twoDimensionArr);
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
   isSuma = 10;
   isResta = 11;
   isMult = 12;
   isDivisionBinaria = 13;
   isTraza = 14;
   isMatrizTriangular = 15;
   h = 0.0001;
implementation

constructor MatrixAlgebra.Create;
begin

end;

function MatrixAlgebra.divideVector(v: ArrayReal; e: Real): arrayReal;
var
  i:Integer;
begin
  setLength(result, length(v));
  for i:=0 to length(v)-1 do
    result[i]:= v[i]/e;
end;

function MatrixAlgebra.restaVectores(v, w:arrayReal): arrayReal;
var
  i:Integer;
begin
  setLength(Result, length(v));

  for i:=0 to length(v)-1 do
    Result[i]:= v[i] - w[i];
end;

function MatrixAlgebra.multiplyVector(v: ArrayReal; e: Real):arrayReal;
var
  i:Integer;
begin
  setLength(Result, length(v));
  for i:=0 to length(v)-1 do
    result[i]:= v[i]*e;
end;


function MatrixAlgebra.matrizTriangular(M: twoDimensionArr): twoDimensionArr;
var
  i,j: Integer;
  tempVector: arrayReal;
begin
  setLength(tempVector, length(m));

  for i:=0 to length(m)-1 do
    for j:=i+1 to length(m)-1 do begin
        tempVector:= divideVector(m[i], m[i,i]);
        tempVector:= multiplyVector(tempVector, m[j,i]);
        m[j]:= restaVectores(m[j], tempVector);
    end;
    Result:= m;
end;

procedure MatrixAlgebra.traza(M:twoDimensionArr);
begin
  resultadoEscalar:= getTraza(M);
end;

function MatrixAlgebra.getTraza(M:twoDimensionArr):Real;
var
  i,j:Integer;
begin
  Result:=0;
  if length(m) < length(m[0]) then
    i := length(m)
  else
    i:= length(m[0]);

  for j:=0 to i-1 do
    Result:= Result + m[j,j];
end;

function MatrixAlgebra.jacobiana(): twoDimensionArr;
var
  parser: TParseMath;
  i,j: Integer;
begin
  parser:= TParseMath.create();
  for i:= 0  to length(values)-1 do
    parser.AddVariable('x'+ IntToStr(i), values[i]);

  SetLength(Result, Length(functionArray), countVariables);
  for i:= 0 to length(functionArray)-1 do begin
    parser.Expression:= functionArray[i];
    for j:= 0 to countVariables -1 do begin
      parser.newValue('x'+ IntToStr(j), values[j]);
      Result[i,j]:= (-1)* parser.evaluate();
      parser.NewValue('x' + IntToStr(j), values[j] + h);
      result[i,j]:= (Result[i,j] + parser.evaluate) / h;
      parser.NewValue('x'+ IntToStr(j), values[j]);
    end;
  end;
end;

function MatrixAlgebra.potenciacion(M:twoDimensionArr):twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result, length(M), Length(M[0]));
  if escalar = 0 then begin
    for i:=0 to length(M)-1 do
      for j:=0 to Length(M[0])-1 do
        if i = j then
          result[i,j] := 0
        else
          result[i,j] := 1;
  end;
  escalar:= escalar-1;

  for i := 0 to length(M) -1 do
    for j:= 0  to length(M[0]) -1 do
      result[i,j] :=M[i,j];

  while(escalar > 0) do begin
    result:= multiplicar(result, M);
    escalar:= escalar-1;
  end;

end;

function MatrixAlgebra.inversa(M:twoDimensionArr):twoDimensionArr;
begin
  escalar:=getDeterminante(M);
  showMessage(FloatToStr(escalar));
  M:=adjunta(M);
  M:=transpuesta(M);
  Result:= dividirEscalar(M);
end;

function MatrixAlgebra.adjunta(M:twoDimensionArr):twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result, length(M), length(M[0]));

  for i:=0 to Length(M)-1 do
    for j:=0 to Length(M[0])-1 do
      if ((i+j) mod 2 = 0) then
        result[i,j] :=  getDeterminante(getArrWithoutRowCol(M, i, j))
      else
        result[i,j] := getDeterminante(getArrWithoutRowCol(M,i,j)) *(-1);
end;

procedure MatrixAlgebra.determinante(M: twoDimensionArr);
begin
  resultadoEscalar := getDeterminante(M);
end;

function MatrixAlgebra.getArrWithoutRowCol(m: twoDimensionArr; rr, cc: Integer): twoDimensionArr;
var
  i,j,actualRow,actualCol: Integer;
  temp: String;
begin
  actualRow:= 0;
  actualCol:= 0;
  showMessage('Length: ' + IntToStr(Length(m)));
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

function MatrixAlgebra.getDeterminante(m: twoDimensionArr): Real;
var
  i: Integer;
begin
  Result:=0;

  if(length(m) = length(m[0])) then begin
    if (length(m) = 1) then begin
      Result:= m[0,0]
    end
    else if (Length(m) = 2) then begin
      Result:= (m[0,0] * m[1,1]) - (m[0,1] * m[1,0])
    end
    else begin
      for i:=0 to length(m)-1 do
        if (i mod 2) = 0 then  begin
          Result:= Result + m[0,i] * getDeterminante(getArrWithoutRowCol(m, 0,i))
        end
        else begin
          Result:= Result - m[0,i]* getDeterminante(getArrWithoutRowCol(m, 0,i));
        end;
    end;
  end;
end;

procedure MatrixAlgebra.ejecutar();
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
          Resultado := dividirEscalar(a);
        end;
      isDeterminante:
        begin
          tempMatrix:=A;
          determinante(tempMatrix);
        end;
      isJacobiana:
        begin
          resultado:= jacobiana();
        end;
      isSuma:
        begin
          resultado:= suma(a,b);
        end;
      isResta:
        begin
          resultado:= resta(a,b);
        end;
      isMult:
        begin
          resultado:= multiplicar(a,b);
        end;
      isDivisionBinaria:
        begin
          resultado:= dividir(a,b);
        end;
      isTraza:
        begin
          traza(a);
        end;
      isMatrizTriangular:
        begin
          resultado:= matrizTriangular(a);
        end;
  end;
end;

function MatrixAlgebra.transpuesta(M: twoDimensionArr):twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result, Length(M), length(M[0]));
  for i:=0 to length(result)-1 do
    for j:=0 to length(result[0])-1 do
      result[i,j]:= M[j,i];

end;
function MatrixAlgebra.sumaEscalar(M: twoDimensionArr):twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result,  Length(M), length(M[0]));
  for i:=0 to length(result)-1 do
    for j:=0 to length(result[0])-1 do
      result[i,j]:= M[i,j]+Escalar;
end;

function MatrixAlgebra.restaEscalar(M: twoDimensionArr):twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result,  Length(M), length(M[0]));
  for i:=0 to length(result)-1 do
    for j:=0 to length(result[0])-1 do
      result[i,j]:= M[i,j]-Escalar;
end;

function MatrixAlgebra.multEscalar(M: twoDimensionArr): twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result,  Length(M), length(M[0]));
  for i:=0 to length(result)-1 do
    for j:=0 to length(result[0])-1 do
      result[i,j]:= M[i,j]*Escalar;
end;

function MatrixAlgebra.dividirEscalar(M: twoDimensionArr): twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result,  Length(M), length(M[0]));
  for i:=0 to length(M)-1 do
    for j:=0 to length(M[0])-1 do
      result[i,j]:= M[i,j]/Escalar;
end;

function MatrixAlgebra.dividir(M,N: twoDimensionArr): twoDimensionArr;
begin
  result:= multiplicar(M, inversa(N));
end;

function MatrixAlgebra.suma(M,N: twoDimensionArr):twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result, length(M), length(M[0]));
  for i:=0 to length(M)-1 do
    for j:=0 to length(M[0])-1 do
      result[i,j]:= M[i,j] + N[i,j];
end;

function MatrixAlgebra.resta(M,N: twoDimensionArr):twoDimensionArr;
var
  i,j: Integer;
begin
  SetLength(result, length(M), length(M[0]));
  for i:=0 to length(M)-1 do
    for j:=0 to length(M[0])-1 do
      result[i,j]:= M[i,j] - N[i,j];
end;

function MatrixAlgebra.multiplicar(M,N: twoDimensionArr):twoDimensionArr;
var
  sum: Real;
  k,i,j: Integer;
begin
  SetLength(result, length(M), length(N[0]));
  sum:=0;
  for i:= 0 to length(result)-1 do begin
    for j:= 0 to Length(result)-1 do begin
      sum:=0;
      for k:=0 to length(N)-1 do
        sum:= sum + (M[i, k] * N[k,j]);
      result[i,j]:= sum;
    end;

  end;
end;
end.
