unit variablesH;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath;
  type arrReal = array of Real;
  type twoDimensionArr= array of arrReal;

var
  filasA, columnasA, filasB, columnasB, filasRes, colsRes : Integer;
  operacionesList: TstringList;
  resultado: twoDimensionArr;
  escalar: Real;
  operacionIndex, countVariables: Integer;
  values: array of Double;
implementation

end.
