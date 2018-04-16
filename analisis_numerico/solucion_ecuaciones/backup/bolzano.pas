unit bolzano;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  MetodosNumericos = class
    a, b, xInit: Real;
    ErrorAllowed: Real;
    minimumsList, maximumsList, metodosList,sequence : TstringList;
    numericMethod : Integer;
    function execute() : Real;
    function f(x: Real) : Real;
    function Bolzano(x1:Real; x2:Real): Boolean;
    function derivada(x: Real) :Real;
    private
      error: Real;
      function falsePosition(): Real;
      function biseccion(): Real;
      function newton():Real;
      function secante():Real;
      function puntoFijo():Real;
    public
          constructor create;
          destructor Destroy; override;


  end;

  const
    isBiseccion = 0;
    NaN = 0.0/0.0;
    isFalsaPosicion = 1;
    IsNewton = 2;
    isSecante =3;
    IsPuntoFijo = 4;
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
       metodosList.AddObject('Newton-Raphson', TObject(IsNewton));
       metodosList.AddObject('Secante', TObject(isSecante));
       metodosList.AddObject('Punto fijo', TObject(IsPuntoFijo));
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
       isNewton: Result:= newton();
       isSecante: Result:= secante();
       IsPuntoFijo: Result:= puntoFijo();
  end;

end;

function metodosNumericos.f(x: Real): Real;
begin
  Result:=x*sin(x*x*x); //primera pregunta
  //Result:=1/x;
  //Result:=2*x*x*x - 2*x*x;
end;

function MetodosNumericos.Derivada(x: Real) :Real;
begin
  Result:= sin(x*x*x) + 3*x*x*x*cos(x*x*x); //primera pregunta
  //Result:= -1/(x*x)
  //Result:= 6*x*x-4*x;
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

function MetodosNumericos.Newton():Real;
var xn: Real;
    n: Integer;
    begin
      Result:= xInit;
      n:=0;
      sequence.Add(floatToStr(Result));
      repeat
             xn:= Result;
             Result:= xn - (f(xn) / derivada(xn));
             sequence.Add(FloatToStr(Result));
             error:= abs(Result - xn);
             n:=n+1;
      until (error < ErrorAllowed) or (n>=Top);
    end;

function MetodosNumericos.secante(): Real;
var xn:Real;
    n:Integer;
    h:real;
    begin
      result:=xInit;
      n:=0;
      h:= ErrorAllowed/10;
      sequence.Add(floatToStr(Result));
      repeat
        xn:=Result;
        Result:= xn - (f(xn)* 2 *h)/ (f(xn+h) - f(xn-h));
        sequence.Add(FloatToStr(Result));
        error:= abs(Result-xn);
        n:= n+1;
      until (error < ErrorAllowed) or (n>=Top) ;
    end;

function MetodosNumericos.puntoFijo(): Real;
var xn: Real;
    n:Integer;
    begin
      result:= xInit;
      n:=0;
      sequence.Add(FloatToStr(Result));
      repeat
            xn:=Result;
            Result:= f(Result);
            sequence.Add(FloatToStr(Result));
            error:= abs(Result-xn);
            n:=n+1;
      until (error < ErrorAllowed) or (n>=Top) ;
    end;

end.





















