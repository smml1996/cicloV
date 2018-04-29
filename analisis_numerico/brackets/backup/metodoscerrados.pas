unit metodosCerrados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath,Dialogs, Math;

type
  bracketMethod = class
  minimumsList, maximumsList, sequence, errorEstimado, errorReal: TstringList;
  a,b: Double;
  ErrorAllowed: Double;
  parser: TParseMath;
  function execute(methodIndex: Integer): Double;
  function biseccion: Double;
  function biseccionEvalMinimized: Double;
  function falsePosition: Double;
  function falsePosEvalMin: Double;
  function modifiedFalsePosition: Double;
  function test(x: Double): Double;
  private
    function bolzano(x1,x2: Double): Boolean;
    function fx(x: Double): Double;
  public
    constructor OnCreate(e: String; aa,bb, EA: Double);
  end;

const
  isBiseccion = 0;
  isFalsaPosicion = 1;
  isBiseccionMin = 2;
  isFalseMin  = 3;
  isModifiedFalse = 4;

implementation
const
  Top = 100000;
  Nan = 0.0 / 0.0;
  neperConst = 2.718281828459045235360;
var
  error: Double;
  ValorReal: Double;

function bracketMethod.execute(methodIndex: Integer):Double;
begin
  valorReal:= 60;
  case methodIndex of
    isBiseccion: Result:=biseccion;
    isFalsaPosicion: Result:= falsePosition;
    isBiseccionMin: Result:= biseccionEvalMinimized;
    isFalseMin: Result:= falsePosEvalMin;
    isModifiedFalse: Result:= modifiedFalsePosition;
  end;
end;

function bracketMethod.fx(x: Double): Double;
begin
  //parser.newValue('x', x);
  //Result:= parser.evaluate;
  Result:=  (667.38/x) * (1  - power(neperConst, -0.146843*x)) - 40;
end;

function bracketMethod.test(x: Double): Double;
begin

  showMessage( 'f(' + FloatToStr(x) + ') = ' + floatToStr(fx(x)));

end;

constructor bracketMethod.onCreate(e: String; aa,bb, EA: Double);
begin
  a:= aa;
  b:= bb;
  ErrorAllowed:= EA;
  parser:= TParseMath.create();
  parser.AddVariable('x',0.0);
  parser.Expression:= e;
  minimumsList:= TStringList.create;
  maximumsList:= TStringList.create;
  sequence:= TStringList.create;
  errorEstimado:= TStringList.create;
  errorReal:= TStringList.create;
  sequence.Add('Xn');
  minimumsList.Add('a');
  maximumsList.Add('b');
  errorReal.Add('Error Real');
  errorEstimado.Add('Error Absoluto');
end;


function bracketMethod.bolzano(x1,x2:Double): Boolean;
begin
  if (fx(x1) * fx(x2)) < 0 then
    result:= True
  else
    result:= False;
end;

function bracketMethod.modifiedFalsePosition: Double;
var xn: Real;
    n,c,it1, it2: Integer;
begin
     error:= Top;
     if not bolzano(a,b) then
        Result:=NaN
     else begin
          it1:= 0;
          it2:= 0;
          Result:= 0;
          n:=0;
          c:= -1;
          errorEstimado.Add('-');
          repeat
            minimumsList.Add(FloatToStr(a));
            maximumsList.Add(FloatToStr(b));
            xn:=Result;
            Result:=a;
            if c = -1 then
              Result:= Result - fx(a)*(b-a)/(fx(b)-fx(a))
            else if c = 1 then
              Result:= Result - fx(a)*(b-a)/((fx(b)/2)-fx(a))
            else
              Result:= Result - (fx(a)/2)*(b-a)/(fx(b)-(fx(a)/2));
            sequence.Add(FloatToStr(Result));
            if n >0 then begin
              error:= abs((Result - xn)/Result);
              errorEstimado.Add(FloatToStr(error));
            end;
            errorReal.Add(FloatToStr( abs(Result - ValorReal)));

            if bolzano(a,b) then begin
               b:=Result;
               it1:= 0;
               it2:= it2 + 1;
               c:=-1;
               if it2 >1 then c := 3;

            end
            else begin
                a:=Result;
                c:= -1;
                it2:= 0;
                it1:= it1 +1;
                if it1 > 1 then c := 1;
            end;
            n:=n+1;
          until (error < ErrorAllowed) or (n>=Top);
     end;


end;

function bracketMethod.biseccion : Double;
var xn: Real;
    n: Integer;
begin

  error:= Top;

  if not bolzano(a,b) then
     Result:= NaN
  else begin
      Result:= 0;
      n:=0;
      errorEstimado.Add('-');
      repeat
        minimumsList.Add(FloatToStr(a));
        maximumsList.Add(FloatToStr(b));
        xn:=Result;
        Result:= (a + b)/2;
        sequence.Add(FloatToStr(Result));
        if (n > 0)  and (result<> 0) then begin
           error:= abs((Result - xn)/result);
           errorEstimado.Add(FloatToStr(error));
        end;
        errorReal.Add(FloatToStr( abs(Result - ValorReal)));
        if (not bolzano(b,result)) or (fx(b) = 0.0) or (fx(result) = 0.0) then
           b:= Result;
        if (not bolzano(a, result)) or (fx(a) = 0.0) or (fx(result) = 0.0) then
          a:=Result;
        n:=n+1;

      until (Error < ErrorAllowed) or (n>=Top);

  end;
end;

function bracketMethod.biseccionEvalMinimized: Double;
var xu, xl,xr, xrold, fl, fr, tt: Real;
    n, nFunctionEvaluations: Integer;
begin

  error:= Top;

  if not bolzano(a,b) then
     Result:= NaN
  else begin
      nFunctionEvaluations:= 0;
      Result:= 0;
      n:=0;
      errorEstimado.Add('-');
      fl:= fx(a);
      nFunctionEvaluations:= nFunctionEvaluations +1;
      xl:= a;
      xu:=b;
      error:= top;
      repeat
        minimumsList.Add(FloatToStr(xl));
        maximumsList.Add(FloatToStr(xu));
        xrold := xr;
        xr:= (xl + xu)/2;
        fr:= fx(xr);
        nFunctionEvaluations:= nFunctionEvaluations +1;
        sequence.Add(FloatToStr(xr));
        if (n > 0)  and (xr <> 0) then begin
           error:= abs((xr  -  xrold)/xr);
           errorEstimado.Add(FloatToStr(error));
        end;
        errorReal.Add(FloatToStr( abs(Result - ValorReal)));
        tt := fl * fr;
        if (tt < 0) then
           xu:= xr
        else if  (tt >  0.0) then begin
          xl:= xr;
          fl:= fr;
        end
        else
          error := 0;
        n:=n+1;

      until (Error < ErrorAllowed) or (n>=Top);

      showMessage('numero de evaluaciones: ' + IntToStr(nFunctionEvaluations));
      Result:=xr;
  end;

end;


function BracketMethod.FalsePosition(): Double;
var xn: Real;
    n: Integer;
begin
     error:= Top;
     if not bolzano(a,b) then
        Result:=NaN
     else begin

          Result:= 0;
          n:=0;
          errorEstimado.Add('-');
          repeat
            minimumsList.Add(FloatToStr(a));
            maximumsList.Add(FloatToStr(b));
            xn:=Result;
            Result:=a;
            Result:= Result - fx(a)*(b-a)/(fx(b)-fx(a));
            sequence.Add(FloatToStr(Result));
            if n >0 then begin
              error:= abs((Result - xn)/Result);
              errorEstimado.Add(FloatToStr(error));
            end;
            errorReal.Add(FloatToStr( abs(Result - ValorReal)));

            if bolzano(a,b) then
               b:=Result
            else
                a:=Result;
            n:=n+1;
          until (error < ErrorAllowed) or (n>=Top);
     end;


end;


function BracketMethod.falsePosEvalMin: Double;
var xn: Real;
    n: Integer;
begin
     error:= Top;
     if not bolzano(a,b) then
        Result:=NaN
     else begin

          Result:= 0;
          n:=0;
          errorEstimado.Add('-');
          repeat
            minimumsList.Add(FloatToStr(a));
            maximumsList.Add(FloatToStr(b));
            xn:=Result;
            Result:=a;
            Result:= Result - fx(a)*(b-a)/(fx(b)-fx(a));
            sequence.Add(FloatToStr(Result));
            if n >0 then begin
              error:= abs((Result - xn)/Result);
              errorEstimado.Add(FloatToStr(error));
            end;
            errorReal.Add(FloatToStr( abs(Result - ValorReal)));

            if bolzano(a,b) then
               b:=Result
            else
                a:=Result;
            n:=n+1;
          until (error < ErrorAllowed) or (n>=Top);

          showMessage('numero de evaluaciones: ' + IntToStr(n));
     end;


end;

end.
