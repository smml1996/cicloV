unit operacionesBinarias;

{$mode objfpc}{$H+}

interface
 uses
     Classes, SysUtils, Graphics,
     FileUtil, Forms, Controls, ExtCtrls,  Grids, Math, variablesh;
type arrayReal = array of Real;
type twoDimensionArray = array of arrayReal;
type operacionesBin = class

    procedure ejecutar(a,b: twoDimensionArray);

    function suma(a,b:twoDimensionArray): twoDimensionArray;
    function resta(a,b:twoDimensionArray): twoDimensionArray;
    function multiplicar(a,b:twoDimensionArray): twoDimensionArray;
    private
    public
          constructor create;

  end;

const
  isSuma = 10;
  isResta = 11;
  isMult = 12;
implementation
var

  i,j,k: Integer;


  constructor operacionesBin.create;
  begin

  end;

procedure operacionesBin.ejecutar(a,b: twoDimensionArray);
begin
  case operacionIndex of
    isSuma:
      begin
        resultado:= suma(a,b);
      end;
    isResta:
      begin
        resultado:= resta(a,b);
      end;
    isMult:
      begin
        resultado:= multiplicar(a,b);
      end;
  end;
end;

function operacionesBin.suma(a,b: twoDimensionArray):twoDimensionArray;
begin
  SetLength(result, length(A), length(A[0]));
  for i:=0 to length(A)-1 do
    for j:=0 to length(A[0])-1 do
      result[i,j]:= A[i,j] + B[i,j];
end;

function operacionesBin.resta(a,b: twoDimensionArray):twoDimensionArray;
begin
  SetLength(result, length(A), length(A[0]));
  for i:=0 to length(A)-1 do
    for j:=0 to length(A[0])-1 do
      result[i,j]:= a[i,j] - b[i,j];
end;

function operacionesBin.multiplicar(a,b: twoDimensionArray):twoDimensionArray;
var
  sum: Real;
begin
  SetLength(result, length(A), length(B[0]));
  sum:=0;
  for i:= 0 to length(result)-1 do begin
    for j:= 0 to Length(result)-1 do begin
      sum:=0;
      for k:=0 to length(b)-1 do
        sum:= sum + (A[i, k] * B[k,j]);
      result[i,j]:= sum;
    end;

  end;
end;

end.
