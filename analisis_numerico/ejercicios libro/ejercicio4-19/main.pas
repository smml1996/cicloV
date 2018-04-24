unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, Forms, Controls, Graphics,
  Dialogs, StdCtrls, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    Chart1FuncSeries1: TFuncSeries;
    Chart1FuncSeries2: TFuncSeries;
    Chart1FuncSeries3: TFuncSeries;
    Chart1FuncSeries4: TFuncSeries;
    Chart2: TChart;
    Chart2FuncSeries1: TFuncSeries;
    Chart2FuncSeries2: TFuncSeries;
    Chart2FuncSeries3: TFuncSeries;
    Chart2FuncSeries4: TFuncSeries;
    Label1: TLabel;
    Label2: TLabel;
    procedure backwardFirst(const AX: Double; out AY: Double);
    procedure backwardSecond(const AX: Double; out AY: Double);
    procedure centeredFirst(const AX: Double; out AY: Double);
    procedure centeredSecond(const AX: Double; out AY: Double);
    procedure exactFirstOrder(const AX: Double; out AY: Double);
    procedure forwardFirst(const AX: Double; out AY: Double);
    procedure forwardSecond(const AX: Double; out AY: Double);
    procedure OnCreate(Sender: TObject);
    procedure segundaExacta(const AX: Double; out AY: Double);
  private

  public

  end;

var
  Form1: TForm1;

const
  h = 0.25;
implementation

{$R *.lfm}

{ TForm1 }

function fx(x: Double) : Double;
begin
  Result:= power(x,3) -2*x + 4;
end;

procedure TForm1.exactFirstOrder(const AX: Double; out AY: Double);
begin
  AY:= 3*power(AX,2) -2;
end;

procedure TForm1.backwardFirst(const AX: Double; out AY: Double);
begin
  AY:= ( fx(AX) - fx(AX-h))/h;
end;

procedure TForm1.backwardSecond(const AX: Double; out AY: Double);
begin
  AY:= (fx(AX) - 2*fx(AX-h) + fx(AX-2*h)) / (h*h);
end;

procedure TForm1.centeredFirst(const AX: Double; out AY: Double);
begin
  AY:= (fx(AX + h) - fx(AX - h)) /(2*h)
end;

procedure TForm1.centeredSecond(const AX: Double; out AY: Double);
begin
  AY:= (((fx(AX + h) - fx(AX)) / h) - ((fx(AX) - fx(AX - h))/h)) / h;

end;

procedure TForm1.forwardFirst(const AX: Double; out AY: Double);
begin
  AY:= (fx(AX+h) - fx(AX))/h;
end;

procedure TForm1.forwardSecond(const AX: Double; out AY: Double);
begin
AY:= (fx(AX + 2*h) - 2*fx(AX+h) + fx(AX))/( h*h)
end;

procedure TForm1.OnCreate(Sender: TObject);
begin
  Chart1.Proportional := true;
  Chart1.Extent.UseXMax := True;
  Chart1.Extent.UseXMin:= True;
  Chart1.Extent.XMin:=0;
  chart1.Extent.XMax:= 1;
  chart1.legend.Visible:=True;
  chart2.legend.Visible:=True;
  Chart2.Proportional := true;
  Chart2.Extent.UseXMax := True;
  Chart2.Extent.UseXMin:= True;
  Chart2.Extent.XMin:=-2;
  chart2.Extent.XMax:= 2;
end;

procedure TForm1.segundaExacta(const AX: Double; out AY: Double);
begin
     AY:= 6*AX;
end;

end.
