unit opMetodos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath, dialogs, Math;

type
  OpenMethod = class
  xInit, ErrorAllowed, multiplicity: Double;
  parser: TParseMath;
  sequence, errorEstimado: TStringList;
  isMethod: Integer;
  function test(x:Double): Double;
  function execute: Double;
  private
    error: Double;
    function fx(x: Double): Double;
    function secante: Double;
    function puntoFijo: Double;
    function newtonRaphson: Double;
    function newtonRaphsonExtended: Double;
    function derivada(x: Double): Double;
    function secondDerivative(x: Double): Double;
  public
    constructor create;
  end;

const
  NaN = 0.0 /0.0;
  isSecante = 0;
  IsPuntoFijo = 1;
  IsNewtonRaphson = 2;
  isNewtonRaphsonExtended = 3;
  h = 0.00001;
implementation

const
  Top = 100000;
  neperConst = 2.718281828459045235360;

  function OpenMethod.secondDerivative(x: Double): Double;
  begin

    Result:= fx(x + h) - (2*fx(x)) + fx(x-h);
    Result:= Result/ power(h,2);

  end;

  constructor OpenMethod.create;
  begin
       sequence:= TStringList.create;
       errorEstimado:= TStringList.create;
       sequence.Add('Xn');
       errorEstimado.Add('Error Estimado');
       error:= Top;
       parser := TParseMath.create;
       parser.AddVariable('x', 0.0);
  end;

  function OpenMethod.execute: Double;
  begin
    case isMethod of
         isNewtonRaphson: Result:= newtonRaphson;
         isSecante: Result:= secante;
         IsPuntoFijo: Result:= puntoFijo;
         isNewtonRaphsonExtended: Result:= newtonRaphsonExtended;
    end;
  end;

  function OpenMethod.fx(x: Double): Double;
  begin
    parser.newValue('x', x);
    Result:= parser.evaluate;
    //Result:= 8* sin(x) * power(neperConst, -x) -1;
  end;

  function OpenMethod.derivada(x: Double): Double;
  begin
    Result:= (fx(x+h) - fx(x))/h;
  end;

  function OpenMethod.test(x: Double): Double;
  begin
    Result:= fx(x);
  end;

  function OpenMethod.newtonRaphson():Double;
  var xn: Real;
      n: Integer;
  begin
    Result:= xInit;
    n:=0;
    sequence.Add(floatToStr(Result));
    errorEstimado.add('-');
    repeat
           xn:= Result;
           Result:= xn - multiplicity*(fx(xn) / derivada(xn));
           sequence.Add(FloatToStr(Result));
           error:= abs((Result - xn)/result);
           errorEstimado.add(FloatToStr(error));
           n:=n+1;
    until (error < ErrorAllowed) or (n>=Top);
  end;

  function OpenMethod.newtonRaphsonExtended():Double;
  var xn: Real;
      n: Integer;
  begin
    Result:= xInit;
    n:=0;
    sequence.Add(floatToStr(Result));
    errorEstimado.add('-');
    repeat
           xn:= Result;
           Result:= xn - (fx(xn)*derivada(xn)) /( power(derivada(xn,2)) - fx(xn)*secondDerivative(xn));
           sequence.Add(FloatToStr(Result));
           error:= abs((Result - xn)/result);
           errorEstimado.add(FloatToStr(error));
           n:=n+1;
    until (error < ErrorAllowed) or (n>=Top);
  end;

  function OpenMethod.secante(): Double;
  var xn:Real;
      n:Integer;
      h2: Double;
  begin
    result:=xInit;
    n:=0;
    h2:= ErrorAllowed/10;
    sequence.Add(floatToStr(Result));
    errorEstimado.add('-');
    repeat
      xn:=Result;
      Result:= xn - (fx(xn)* 2 *h2)/ (fx(xn+h2) - fx(xn-h2));
      sequence.Add(FloatToStr(Result));
      error:= abs((Result-xn)/result);
      errorEstimado.add(FloatToStr(error));
      n:= n+1;
    until (error < ErrorAllowed) or (n>=Top) ;
  end;

  function OpenMethod.puntoFijo():Double;
  var xn: Real;
      n:Integer;
    begin
      result:= xInit;
      n:=0;
      sequence.Add(FloatToStr(Result));
      errorEstimado.add('-');

      repeat
            xn:=Result;
            if(abs(derivada(xn)) >= 1) then begin
              showMessage('derivada mayor a 1 en iteracion = ' + IntToStr(n) + ', Derivada = ' + floatToStr(derivada(xn)));
              break;
            end;
            Result:= fx(Result);
            sequence.Add(FloatToStr(Result));
            error:= abs((Result-xn)/result);
            errorEstimado.add(FloatToStr(error));
            n:=n+1;
      until (error < ErrorAllowed) or (n>=Top) ;
    end;

end.
