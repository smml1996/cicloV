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
  function falsePosition: Double;
  private
    function bolzano(x1,x2: Double): Boolean;
    function fx(x: Double): Double;
  public
    constructor OnCreate(e: String; aa,bb, EA: Double);
  end;

const
  isBiseccion = 0;
  isFalsaPosicion = 1;

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
  end;
end;

function bracketMethod.fx(x: Double): Double;
var
  TA: Double;
begin
  //parser.newValue('x', x);
  //Result:= parser.evaluate;
  TA:= x + 273.15;
  Result:= -139.34411 + ((157570.1)/ (TA)) - ((66423080)/ (power(TA,2)));
  result:= Result + ((1243800* power(10,4))/ power(TA, 3)) - ((8621949000 * power(10,2))/ power(TA,4));

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
        if n > 0 then begin
           error:= abs((Result - xn));
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

end.
