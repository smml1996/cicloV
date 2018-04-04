unit bolzano;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  MetodosNumericos = class
    a, b: Real;
    ErrorAllowed: Real;
    minimumsList, maximumsList, metodosList,sequence : TstringList;
    numericMethod : Integer;
    function execute() : Real;
    function f(x: Real) : Real;
    function Bolzano(x1:Real; x2:Real): Boolean;
    private
      error: Real;
      function falsePosition(): Real;
      function biseccion(): Real;
    public
          constructor create;
          destructor Destroy; override;


  end;

  const
    isBiseccion = 0;
    NaN = 0.0/0.0;
    isFalsaPosicion = 1;
implementation

const
  Top = 100000;



  constructor MetodosNumericos.create;
  begin
       minimumsList:= TStringList.create;
       maximumsList:= TStringList.create;
       metodosList:= TStringList.create;
       sequence:= TStringList.create;
       sequence.Add('Xn');
       minimumsList.Add('a');
       maximumsList.Add('b');
       metodosList.AddObject('Biseccion', TObject(isBiseccion));
       metodosList.AddObject('Falsa Posicion', TObject(isFalsaPosicion));
       error:= Top;
  end;

destructor MetodosNumericos.Destroy;
begin
  minimumsList.Destroy;
  maximumsList.Destroy;
  metodosList.Destroy;
end;

function MetodosNumericos.execute() : Real;
begin
  case numericMethod of
       isBiseccion: Result:= biseccion();
       isFalsaPosicion: Result:= falsePosition();
  end;

end;

function metodosNumericos.f(x: Real): Real;
begin
  //Result:= x*x;
  //Result:= x*x *(sqrt(sqrt(3)) - 6)/(x*x-1) ;
  //Result:= x*x*x-3*x;
  Result:=x*x*x -x*x-2*x+4;
end;

function MetodosNumericos.Bolzano(x1:Real; x2:Real): Boolean;
begin
   if f(x1) * f(x2) <= 0 then
      Result:= true
   else
     Result:=False;
end;

function MetodosNumericos.biseccion(): Real;
var xn: Real;
    n: Integer;
begin

  if not bolzano(a,b) then
     Result:= NaN
  else begin
      Result:= 0;
      n:=0;
      repeat
        minimumsList.Add(FloatToStr(a));
        maximumsList.Add(FloatToStr(b));
        xn:=Result;
        Result:= (a + b)/2;
        sequence.Add(FloatToStr(Result));
        if n > 0 then
           error:= abs(Result - xn);

        if bolzano(a,b) then
           b:= Result
        else
          a:=Result;
        n:=n+1;

      until (Error < ErrorAllowed) or (n>=Top);
      minimumsList.Add(FloatToStr(a));
      maximumsList.Add(FloatToStr(b));
      Result:= (a+b)/2;
      sequence.Add(FloatToStr(Result)) ;

  end;
end;

function MetodosNumericos.FalsePosition(): Real;
var xn: Real;
    n: Integer;
begin
     if not bolzano(a,b) then
        Result:=NaN
     else begin

          Result:= 0;
          n:=0;
          repeat
            minimumsList.Add(FloatToStr(a));
            maximumsList.Add(FloatToStr(b));
            xn:=Result;
            Result:=a;
            Result:= Result - f(a)*(b-a)/(f(b)-f(a));
            sequence.Add(FloatToStr(Result));
            if n >0 then
               error:= abs(Result - xn);
            if bolzano(a,b) then
               b:=Result
            else
                a:=Result;
            n:=n+1;
          until (error < ErrorAllowed) or (n>=Top);

          minimumsList.Add(FloatToStr(a));
          maximumsList.Add(FloatToStr(b));
          Result:=a;
          Result:= Result - f(a)*(b-a)/(f(b)-f(a));
          sequence.Add(FloatToStr(Result));
     end;


end;

end.





















