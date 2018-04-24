unit variablesH;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
  type arrReal = array of Real;
  type twoDimensionArr= array of arrReal;
  type doubleArr = array of Double;
  type twoDimensionDouble = array of doubleArr;
  type stringArray = array of String;

var
  filasA, columnasA, filasB, columnasB, filasRes, colsRes : Integer;
  operacionesList: TstringList;
  resultado: twoDimensionArr;
  A,B: twoDimensionArr;
  escalar: Real;
  operacionIndex, countVariables: Integer;
  resultadoEscalar: Real;
  values: twoDimensionDouble;
  functionArray: array of String;
implementation

end.
