unit variablesH;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
  type arrReal = array of Real;
  type twoDimensionArr= array of arrReal;
  type doubleArray = array of Double;
  type stringArray = array of String;

var
  filasA, columnasA, filasB, columnasB, filasRes, colsRes : Integer;
  operacionesList: TstringList;
  resultado: twoDimensionArr;
  A,B: twoDimensionArr;
  escalar: Real;
  operacionIndex, countVariables: Integer;
  resultadoEscalar: Real;
  values: doubleArray;
  functionArray: array of String;
implementation

end.
