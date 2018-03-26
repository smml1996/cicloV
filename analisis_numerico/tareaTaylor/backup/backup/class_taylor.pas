unit class_taylor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TTaylor = class
    ErrorAllowed: Real;
    sequence: TstringList;
    functionType: Integer;
    AngleType: Integer;
    x: Real;
    a:Real;
    function Execute(): Real;
    private:
      error, temp, Angle: Real;
      function sen(): Real;
      function cos(): Real;
      function asinh():Real;
      function ln(): Real;
      function arcsin(): Real;
      function arctan(): Real;
      function sinh(): Real;
      function cosh(): Real;
      function tanhInverse(): Real;
      function geometrica(): Real;

    public:
      constructor create;
      destructor Destroy; override;
  end;
  const
    IsSin= 0;
    IsCos= 1;
    IsAsinh = 2;
    IsLn = 3;
    IsArcsin = 4;
    IsArctan = 5;
    IsSinh = 6;
    IsCosh = 7;
    IsTanhInverse = 8;
    IsGeometrica = 9;

    AngleSexadecimal = 0;
    AngleRadianes = 1;
implementation

const
  Top = 100000;

constructor TTaylor.create;
begin
  sequence:= TStringList.Create;
  sequence.Add('');
  error:= Top;
  x:=0;
end;

destructor TTaylor.Destroy;
begin
  Sequence.Destroy;
end;

function TTaylor.Execute() : Real;
begin

  case AngleType of
       AngleRadianes: Angle:=x;
       AngleSexadecimal: Angle:=x * pi/180;
  end;

  case functionType of
       IsSin: Result:= sen();
       IsCos: Result:= cos();
       IsAsinh: Result:= asinh();
       isLn: Result:= ln();
       IsArcsin: Result:= arcsin();
       isArctan: Result:= arctan();
       isSinh: Result:= sinh();
       isCosh: Result:=cosh();
       isTanhInverse: Result:= tanhInverse();
       isGeometrica: Result:= geometrica();
  end;
end

function power(b: Real; n: Real): Real;
var i: Integer;
begin
   Result:=1;
   for i:=1 to n do
       Result:= Result * b;
end;

function factorial(n: Integer): Integer;
begin
  if n > 1 then
     Result:= n * factorial(n-1);
  else if n = 0 then
       Result:= 1;
  else
      Result:= 0;
end;

function TTaylor.sen(): Real;
var xn: Real;
    n: Integer;

begin
  Result:= 0;
  n:=0;

  repeat
     xn := Result;
     Result := Result + power(-1, n)* power(Angle, (2*n) +1)/factorial(2*n +1);
     if n > 0 then
          error:= abs(Result-xn);
     sequence.Add(FloatToStr(Result));
     n:= n+1;
  until (error<= ErrorAllowed) or (n >= Top);
end;

function TTaylor.cos(): Real;
var xn: Real;
    n: Integer;

begin
  Result:= 0;
  n:= 0;

  repeat
     xn := Result;
     Result := Result + power(-1,n) * power(Angle, 2*n)/ factorial(2*n);
     if n > 0 then
          error:= abs(Result - xn);
     sequence.Add(FloatToStr(Result));
     n:= n+1;
  until(error<= ErrorAllowed) or (n >= Top);
end;

function TTaylor.asinh(): Real;
var xn: Real;
    n: Integer;
begin
     result:= 0;
     n:= 0;
     repeat
        xn := Result;
        Result:= Result + (    power(-1, n) * factorial(2*n)*power(Angle, 2*n+1))/ (power(4, n) * power(factorial(n),2) * (2*n+1));
        if n>0 then
             error:= abs(Result - xn);
        sequence.Add(FloatToStr(Result));
        n:= n+1;
     until(error <= ErrorAllowed) or (n>= Top);
end;

function TTaylor.ln(): Real;
var xn: Real;
    n: Integer;
begin
  result:=0;
  n:=1;
  repeat
     xn:= Result;
     Result:= Result+ power(-1, n+1)* power(Angle, n)/ n;
     if n>0 then
          error:= abs(Result - xn);
     sequence.Add(FloatToStr(Result));
     n:= n+1;
  until (error<= ErrorAllowed) or (n>= Top);
end;

function TTaylor.arcsin(): Real;
var xn: Real;
    n: Integer;
begin
     Result:= 0;
     n:= 0;
    repeat
      xn:= Result;
      Result:= Result + (factorial(2*n)) / (power(4, n) * power(factorial(n),2)*(2*n+1)) * power(Angle, 2*n+1);
      if n>0 then
           error:= abs(Result - xn);
      sequence.Add(FloatToStr(Result));
      n:= n+1;
    until (error <= ErrorAllowed) or (n>=Top);
end;

function TTaylor.arctan(): Real;
var xn: Real;
    n: Integer;
begin
  Result:= 0;
  n:= 0;
  repeat
    xn:= Result;
    Result:= Result + power(-1, n) * power(Angle, 2*n+1)/(2*n+1);
    if n>0 then
         error:= abs(Result - xn);
    sequence.Add(FloatToStr(Result));
    n:= n+1;
  until (error<= ErrorAllowed) or (n>=Top);
end;


function TTaylor.sinh(): Real;
var xn: Real;
    n: Integer;
begin
     Result:= 0;
     n:= 0;
     repeat
           xn:=Result;
           Result:= Result + power(Angle, 2*n+1)/ factorial(2*n+1);
           if n>0 then
                error:= abs(Result - xn);
           sequence.Add(FloatToStr(Result));
           n:= n+1;
     until (error <= ErrorAllowed) or (n>= Top);
end;

function TTaylor.cosh(): Real;
var xn: Real;
    n: Integer;
begin
     Result:= 0;
     n:= 0;
     repeat
           xn:= Result;
           Result:= Result+ power(Angle, 2*n)/ factorial(2*n);
           if n > 0 then
              error := abs(Result - xn);
           sequence.Add(FloatToStr(Result));
           n:= n+1;
     until(error <= ErrorAllowed) or  (n>=Top);
end;

function TTaylor.tanhInverse(): Real;

var xn: Real;
    n: Integer;
begin
  Result: =0;
  n:= 0;
  repeat
        xn:=Result;
        Result:= Result + power(Angle, 2*n+1)/ (2*n+1);
        if n>0 then
           error:= abs(Result - xn);
        sequence.Add(FloatToStr(Result));
        n:= n+1;
  until(error <= ErrorAllowed) or (n>= Top);

end;

function TTaylor.geometrica(): Real;
var xn: Real;
    n: Integer;
begin
  Result:= 0;
  n:= 0;
  repeat
        xn:= Result;
        Result:= Result + a*power(x, n);
        if n > 0 then
           error:= abs(Result - xn);
        sequence.Add(FloatToStr(Result));
        n:= n+1;
  until (error < = ErrorAllowed) or (n>=Top);
end;

end;























end.

