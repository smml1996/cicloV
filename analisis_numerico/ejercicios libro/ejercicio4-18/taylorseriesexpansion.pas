unit taylorSeriesExpansion;

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
    Chart2: TChart;
    Chart2FuncSeries1: TFuncSeries;
    Chart3: TChart;
    Chart3FuncSeries1: TFuncSeries;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure cuartoOrden(const AX: Double; out AY: Double);
    procedure drawFx(const AX: Double; out AY: Double);
    procedure OnCreate(Sender: TObject);
    procedure segundoOrden(const AX: Double; out AY: Double);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }



function fx(x: Double): Double;
begin
  Result:= x -1 - 0.5 * sin(x);
end;
procedure TForm1.drawFx(const AX: Double; out AY: Double);
begin
   AY:= abs(fx(AX)- Ax + 1.5);
end;

procedure TForm1.cuartoOrden(const AX: Double; out AY: Double);
begin
  AY:=ABS(Ax-1.5+0.25*((AX-0.5*PI)*(AX-0.5 * PI ))-(1/48)*power((AX-0.5*pi),4)- fx(AX));
end;



procedure TForm1.OnCreate(Sender: TObject);
begin
  Chart1.Proportional := true;
  Chart1.Extent.UseXMax := True;
  Chart1.Extent.UseXMin:= True;
  Chart1.Extent.XMin:=0;
  chart1.Extent.XMax:= 3.16;
  Chart2.Proportional := true;
  Chart2.Extent.UseXMax := True;
  Chart2.Extent.UseXMin:= True;
  Chart2.Extent.XMin:=0;
  chart2.Extent.XMax:= 3.16;
  Chart3.Proportional := true;
  Chart3.Extent.UseXMax := True;
  Chart3.Extent.UseXMin:= True;
  Chart3.Extent.XMin:=0;
  chart3.Extent.XMax:= 3.16;
end;

procedure TForm1.segundoOrden(const AX: Double; out AY: Double);
begin
     AY:= AX - 1.5 +0.25* (power(Ax-0.5*PI,2)) - fx(AX);
end;

end.
