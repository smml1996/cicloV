unit newtonGeneralizado;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, algebraMatrices, Math, variablesH, ParseMath, Dialogs;

  type CNewtonGeneral = class
    allowedError: Double;
    version: Integer;
    errorEstimado: TstringList;
    sequence: TstringList;
    function execute: twoDimensionDouble;
    function SinAproximacion: twoDimensionDouble;
    function ConAproximacion: twoDimensionDouble;
  private
    fn: twoDimensionDouble;

    function getXString(v: twoDimensionDouble) : String;
    function getDistance(v1,v2: twoDimensionDouble) : Double;
    function getNorma(v1: twoDimensionDouble): Double;
    procedure calculateFn;

  protected

  public

  end;

const
  isConAprox = 1;
  isSinAprox = 0;
implementation

const
  Top = 50000;

function CNewtonGeneral.getNorma(v1: twoDimensionDouble) : Double;
var
  i: Integer;
begin
  Result:= 0;

  for i:= 0 to length(v1)-1 do
    Result:= power(v1[i,0],2) + Result;

  Result:= sqrt(result);
end;
function CNewtonGeneral.execute: twoDimensionDouble;
begin
  showMessage(IntToStr(version));
  case version of
       isSinAprox: Result:= SinAproximacion;
       isConAprox: Result:= ConAproximacion;
  end;
end;

function fx: Double;
begin
  Result:= values[0,0] * values[0,0] + 3*power(values[1,0],2);
  Result:= Result + power(constNeper, values[2,0]) + values[3,0];
  result:= Result - 4.71828183;
end;

function CNewtonGeneral.ConAproximacion: twoDimensionDouble;
var
  error: Double;
  n: Integer;
  xn, temp, deltaF, deltaX, prevF, inverseJacobiana: twoDimensionDouble;
  calculadoraMatrix: MatrixAlgebra;
begin

  error:= Top;
  calculadoraMatrix:= MatrixAlgebra.create;
  errorEstimado:= TstringList.create;
  sequence:= TstringList.create;
  errorEstimado.Add('Error Estimado');
  sequence.Add('Xn');
  n:= 1;
  result:= values;
  calculateFn;
  temp:=calculadoraMatrix.jacobiana;
  inverseJacobiana:=calculadoraMatrix.inversa(temp);
  temp:= calculadoraMatrix.multiplicar(inverseJacobiana, fn);
  xn:=Result;
  Result:= calculadoraMatrix.resta(result, temp) ;
  error:= getDistance(result, xn);
  errorEstimado.add(FloatToStr(error));
  sequence.Add(getXString(result));
  prevF:= fn;
  while (n<Top) and (Error >= AllowedError) do
  begin

    deltaX:= calculadoraMatrix.resta(Result, xn);
    xn:= Result;
    values:= Result;
    calculateFn;
    deltaF:= calculadoraMatrix.resta(fn, prevF);
    temp:= calculadoraMatrix.multiplicar(inverseJacobiana, deltaF);
    temp:= calculadoraMatrix.resta(deltaX , temp);
    temp:= calculadoraMatrix.multiplicar(temp, calculadoraMatrix.transpuesta(deltaF));
    escalar:=power(getNorma(deltaF),2);
    temp:= calculadoraMatrix.dividirEscalar(temp);
    inverseJacobiana:= calculadoraMatrix.suma(inverseJacobiana, temp);
    temp:= calculadoraMatrix.multiplicar(inverseJacobiana, fn);
    Result:= calculadoraMatrix.resta(xn,temp);
    error:= getDistance(result, xn);
    errorEstimado.add(FloatToStr(error));
    sequence.Add(getXString(result));
    prevF:= fn;

    n:=n+1;
  end;

end;

procedure CNewtonGeneral.calculateFn;
var
  i: Integer;
  parser: TParseMath;
begin
  parser:= TParseMath.create;
  setLength(fn, length(values), 1);
  for i:= 0  to length(values)-1 do
    parser.AddVariable('x'+ IntToStr(i), values[i,0]);

  for i:= 0 to length(functionArray)-1 do begin
      parser.Expression:= functionArray[i];
      fn[i,0]:= parser.evaluate;
  end;

end;
function CNewtonGeneral.getDistance(v1,v2: twoDimensionDouble): Double;
var
  i: Integer;
begin
  Result:=0;

  for i:= 0 to length(v1)-1 do
    Result:= Result + power(v1[i,0] - v2[i,0], 2);

  Result:= sqrt(Result);
end;


function CNewtonGeneral.getXString(v: twoDimensionDouble): String;
var
  i: Integer;
begin

  Result:= '[ ';

  for i:= 0 to length(v)-2 do
    result:= Result + FloatToStr(v[i,0]) + ', ';
  result:= result + FloatToStr(v[length(v)-1,0]) + ' ]';
end;

function CNewtonGeneral.SinAproximacion : twoDimensionDouble;

var
  error: Double;
  n: Integer;
  xn, temp: twoDimensionDouble;
  calculadoraMatrix: MatrixAlgebra;
begin

  error:= Top;
  calculadoraMatrix:= MatrixAlgebra.create;
  errorEstimado:= TstringList.create;
  sequence:= TstringList.create;
  errorEstimado.Add('Error Estimado');
  sequence.Add('Xn');
  n:= 0;
  result:= values;
  calculateFn;

  showMessage('sin aprox');

  repeat
    xn:=Result;

    temp:=calculadoraMatrix.jacobiana;
    temp:=calculadoraMatrix.inversa(temp);
    temp:= calculadoraMatrix.multiplicar(temp, fn);
    Result:= calculadoraMatrix.resta(result, temp) ;
    sequence.Add(getXString(result));
    values:= Result;

    calculateFn;
    error:= getDistance(result, xn);
    errorEstimado.add(FloatToStr(error));

    n:=n+1;

  until (Error < allowedError) or (n>=Top);

end;




end.
