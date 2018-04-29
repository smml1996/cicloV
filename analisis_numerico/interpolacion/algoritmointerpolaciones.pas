unit algoritmoInterpolaciones;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math,Dialogs, ParseMath;

type doubleArr = array of Double;
type interpolacion = class
  parser: TParseMath;
  GradoPolinomio: Integer;
  function predecir(x: Double): Double;
  procedure insertValues(x,y: Double);
private
  valuesX, ValuesY: doubleArr;
  chosenValuesX, chosenValuesY: doubleArr;
  function getLangrageano(actualIndex: Integer): String;
  procedure shiftOne(pos: Integer);
  procedure getClosestPoints(x: double);
  function getReferenceIndex(x: Double):Integer;

  function isInRange(x: Double): Boolean;
  function polinomiosLagrange: String;

public
  constructor Create();
end;
implementation

  function interpolacion.getReferenceIndex(x:Double): integer;
  var
    i: Integer;
  begin

    for i:= 0 to Length(valuesX)-1 do begin
      if valuesX[i] > x then begin
        Result:= i-1;
        break;
      end;
    end;

  end;

  procedure interpolacion.getClosestPoints(x: Double);
  var
    i,j: Integer;
  begin
    i:= getReferenceIndex(x);
    j:= i+1;

    while (length(chosenValuesX) < GradoPolinomio +1) do begin
      if (i >=0) and (j < Length(valuesX)) then begin
        setLength(chosenValuesY, Length(chosenValuesY)+1);
        setLength(chosenValuesX, Length(chosenValuesX)+1);
        if abs(x - valuesX[i]) < abs(x-valuesX[j]) then begin
          chosenValuesX[length(chosenValuesX)-1] := valuesX[i];
          chosenValuesY[Length(chosenValuesY)-1] := valuesY[i];
          i:= i-1;
        end
        else begin
          chosenValuesX[length(chosenValuesX)-1] := valuesX[j];
          chosenValuesY[Length(chosenValuesY)-1] := valuesY[j];
          j:= j+1;
        end;
      end
      else if i>=0 then begin
        setLength(chosenValuesY, Length(chosenValuesY)+1);
        setLength(chosenValuesX, Length(chosenValuesX)+1);
        chosenValuesX[length(chosenValuesX)-1] := valuesX[i];
        chosenValuesY[Length(chosenValuesY)-1] := valuesY[i];
        i:= i-1;
      end
      else if j < Length(valuesX) then begin
        setLength(chosenValuesY, Length(chosenValuesY)+1);
        setLength(chosenValuesX, Length(chosenValuesX)+1);
        chosenValuesX[length(chosenValuesX)-1] := valuesX[j];
        chosenValuesY[Length(chosenValuesY)-1] := valuesY[j];
        j:= j+1;
      end
      else
        break;

    end;

   for i:= 0 to length(chosenValuesX)-1 do
      showMessage(FloatToStr(chosenValuesX[i]) + ' ' + FloatToStr(chosenValuesY[i]));



  end;
  procedure interpolacion.insertValues(x,y: Double);
  var
    i: Integer;
    found: boolean;
  begin

    if Length(valuesX) = 0 then begin
      setLength(valuesX, 1);
      setLength(valuesY, 1);
      valuesX[0] := x;
      valuesY[0] := y;
    end
    else begin
      found:= false;
      for i:= 0 to length(valuesX)-1 do begin
        if valuesX[i] > x then begin
          shiftOne(i);
          valuesX[i]:= x;
          valuesY[i]:= y;
          found:= true;
          break;
        end;
      end;



      if not found then begin
        setLength(valuesX, Length(valuesX)+1);
        setLength(valuesY, Length(valuesY)+1);
        valuesX[Length(valuesY)-1] := x;
        valuesY[Length(valuesY)-1] := y;
      end;
    end;

    for i:=0 to length(valuesX)-1 do
      showMessage(FloatToStr(valuesX[i]) + ' ' +FloatToStr(valuesY[i]));


  end;

  procedure interpolacion.shiftOne(pos: Integer);
  var
    i: Integer;
  begin
    setLength(valuesX, Length(valuesX)+1);
    setLength(valuesY, Length(valuesY)+1);

    for i:= length(valuesX)-2 downto pos do begin
      valuesX[i+1] := valuesX[i];
      valuesY[i+1] := valuesY[i];
    end;

  end;
  function interpolacion.predecir(x: Double): Double;
  var
    i: Integer;
  begin
    setLength(chosenValuesY,0);
    setLength(chosenValuesX,0);
    if not isInRange(x) then
      showMessage('el valor no esta dentro del dominio');
    getClosestPoints(x);
    for i:= 0 to length(chosenValuesX)-1 do
    parser.Expression:= polinomiosLagrange;
    showMessage(parser.Expression);
    parser.newValue('x', x);
    Result:= parser.evaluate;
  end;

  function interpolacion.isInRange(x: Double):Boolean;
  begin
    if length(valuesX) = 0 then
      Result:= False
    else if (valuesX[0]<= x) and (valuesX[length(valuesX)-1] >= x) then
      Result:= true
    else
      Result:= False;
  end;



  constructor interpolacion.Create();
  var
    i:Integer;
  begin
    setLength(valuesX,0);
    setLength(valuesY, 0);
    parser:= TParseMath.create;
    parser.AddVariable('x', 0.0);

  end;

  function interpolacion.getLangrageano(actualIndex: Integer): String;
  var
    i: Integer;
    denominador: Double;
  begin
    Result:= '1';
    denominador:= 1;
    for i:= 0 to length(chosenValuesX)-1 do
      if i <> actualIndex then begin
        Result:= Result + ' * (x - '+  FloatToStr(chosenValuesX[i])+')';
        denominador:= denominador * (chosenValuesX[actualIndex] - chosenValuesX[i]);
      end;
      Result:= Result + '/' + FloatToStr(denominador);
  end;

  function interpolacion.polinomiosLagrange: String;
  var
    i: Integer;
  begin
    Result := '0';
    for i:= 0 to length(chosenValuesX)-1 do
      Result:= Result + '+ (' + FloatToStr(chosenValuesY[i]) + ' * ' + getLangrageano(i) + ')'

  end;
end.
