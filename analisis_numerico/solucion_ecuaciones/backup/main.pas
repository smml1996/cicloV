unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries, Forms, Controls,
  Graphics, Dialogs, Grids, StdCtrls, ComCtrls, ExtCtrls, math, bolzano;

type

  { TForm1 }

  TForm1 = class(TForm)
    resultado: TLabel;
    metodosInput: TComboBox;
    ejecutar: TButton;
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Chart1FuncSeries1: TFuncSeries;
    Chart1LineSeries1: TLineSeries;
    error: TLabeledEdit;
    tableOutput: TStringGrid;
    trackMin: TTrackBar;
    trackMax: TTrackBar;
    procedure calculateGraph(const AX: Double; out AY: Double);
    procedure ejecutarNow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure trackMaxOnChange(Sender: TObject);
    procedure trackMinOnChange(Sender: TObject);
  private
     metodoNum : MetodosNumericos;

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Chart1.Proportional := true;
  Chart1.Extent.UseXMax:=true;
  Chart1.Extent.UseXMin:=true;
  Chart1.Extent.XMin:=TrackMin.Position;
  chart1.Extent.XMax:= TrackMax.Position;
  metodoNum:= MetodosNumericos.create;
  metodosInput.Items.Assign(metodoNum.metodosList);
end;


procedure TForm1.ejecutarNow(Sender: TObject);

var
  temp : Real;
  procedure fillGrid;
  var i : Integer;
  begin
    with tableOutput do
    for i:=1 to RowCount -1 do begin
      Cells[0,i]:= IntToStr(i);
      if metodoNum.bolzano(StrToFloat(Cells[1,i]), StrToFloat(Cells[2,i])) then
         Cells[4,i] :='-'
      else
          Cells[4,i] := '+';

      if i >=2 then
         Cells[5,i] := FloatToStr(abs(StrToFloat(metodoNum.sequence[i]) - StrToFloat(metodoNum.sequence[i-1])));
    end;
  end;

begin
  metodoNum:= MetodosNumericos.Create;
  metodoNum.numericMethod := metodosInput.ItemIndex;
  metodoNum.errorAllowed:= StrToFloat(error.Text);
  writeLn(metodoNum.errorAllowed);344
  metodoNum.a := trackMin.Position;
  metodoNum.b := trackMax.Position;
  temp:= metodoNum.execute();
  //resultado.Caption:= FloatToStr(temp);
  if not isNan(Temp) then begin
    chart1LineSeries1.ShowLines:=false;
    chart1LineSeries1.ShowPoints:=true;
    chart1LineSeries1.AddXY(temp, metodoNum.f(temp));
  end;
  with tableOutput do begin
    RowCount:=MetodoNum.sequence.Count;
    cols[1].Assign(metodoNum.minimumsList);
    cols[2].Assign(metodoNum.maximumsList);
    cols[3].Assign(metodoNum.sequence);
  end;

  fillGrid;



end;

procedure TForm1.calculateGraph(const AX: Double; out AY: Double);
begin
  AY:= metodoNum.f(AX);
end;


procedure TForm1.trackMaxOnChange(Sender: TObject);
begin
  Chart1.Extent.Xmax:= trackMax.Position;

end;

procedure TForm1.trackMinOnChange(Sender: TObject);
begin

  Chart1.Extent.XMin:= trackMin.Position;

end;

end.

end.

