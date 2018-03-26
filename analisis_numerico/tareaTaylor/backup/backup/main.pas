unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Grids;

type

  { TformGeneral }

  TformGeneral = class(TForm)
    inputFunciones: TComboBox;
    inputAngleType: TComboBox;
    execute: TButton;
    error: TLabeledEdit;
    A: TLabeledEdit;
    resultadoLabel: TLabel;
    iteracionesGrid: TStringGrid;
    x: TLabeledEdit;
    procedure Destroy(Sender: TObject);
    procedure executeTaylor(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  formGeneral: TformGeneral;

implementation

const
ColN = 1;
ColSequence = 2;
ColError = 3;

{$R *.lfm}

{ TformGeneral }

procedure TformGeneral.FormCreate(Sender: TObject);
begin
  inputFunciones.Items.add('sen');
  inputFunciones.Items.add('cos');
  inputFunciones.Items.add('asinh');
  inputFunciones.Items.add('ln(1+x)');
  inputFunciones.Items.add('arcsin');
  inputFunciones.Items.Add('arctan');
  inputFunciones.Items.Add('sinh');
  inputFunciones.Items.Add('cosh');
  inputFunciones.Items.Add('atanh');
  inputFunciones.Items.Add('geometrica');
  inputAngleType.Items.Add('sexagedecimal');
  inputAngleType.Items.Add('radianes');

end;

procedure TformGeneral.Destroy(Sender: TObject);
begin

end;

procedure TformGeneral.executeTaylor(Sender: TObject);
var
  xx : Real;
  aa: Real;
  f: Integer;
  procedure fillGrid;
  var i: Integer;
    Error: Real;
  begin
     with iteracionesGrid do
     for i:= 1 to RowCount -1 do begin
         case f of
              0: error:= sin(xx);
              1: error:= Cos(xx);
              2: error:= arsinh(xx);
              3: error:= lnxp1(xx);
              4: error:= arcsin(xx);
              5: error:= arctan2(xxx,1);
              6: error:=sinh(xx);
              7: error:= cosh(xx);
              8: error:= artanh(xx);
              9: error:= aa/(1-xx);
         end;

         error:= abs(error - StrToFloat( Cells[ColSequence, i] ));
         Cells[ColN, i]:= IntToStr(i);
         Cells[ColError, i]:= FloatToStr(error);
     end;

  end;

begin
  Taylor:= TTaylor.create;
  Taylor.x := StrToFloat(x.Text);
  x:= Taylor.x;
  f:= Integer(inputFunciones.ItemIndex)-1;
  a:= StrToFloat(A.text);
  Taylor.a := a;
  Taylor.functionType:= f;
  Taylor.ErrorAllowed:= StrToFloat(error.Text);
  Taylor.AngleType:= Integer(inputAngleType.ItemIndex)-1;
  resultadoLabel.Text:= FloatToStr(Taylor.execute());

  with iteracionesGrid do begin
      RowCount:= Taylor.sequence.Count;
      Cols[ColSequence].Assign(Taylor.sequence);
  end;

  fillGrid;


end;

end.

