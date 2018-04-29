unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, metodosCerrados;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    testInput: TEdit;
    errorPorcInput: TEdit;
    metodoInput: TComboBox;
    functionInput: TEdit;
    inputB: TEdit;
    inputA: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StringGrid1: TStringGrid;
    procedure ejecutar(Sender: TObject);
    procedure onCreate(Sender: TObject);
    procedure probar(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ejecutar(Sender: TObject);
var
  metodo: bracketMethod;
begin
  metodo:= bracketMethod.OnCreate(functionInput.text, StrToFloat(inputA.Text), StrToFloat(inputB.Text), (StrToFloat(errorPorcInput.Text)/100.00));

  testInput.text := FloatToStr(metodo.execute(metodoInput.ItemIndex));
  with StringGrid1 do begin
    RowCount:= metodo.sequence.Count;
    cols[0].Assign(metodo.minimumsList);
    cols[1].Assign(metodo.maximumsList);
    cols[2].Assign(metodo.sequence);
    cols[3].Assign(metodo.errorEstimado);
    cols[4].Assign(metodo.errorReal);
  end;
end;

procedure TForm1.onCreate(Sender: TObject);
var
  metodosList: TStringList;
begin
  metodosList:= TStringList.create;
  metodosList.AddObject('Bisección', TObject(isBiseccion));
  metodosList.AddObject('Falsa Posición', TObject(isFalsaPosicion));
  metodosList.AddObject('Bisecc. Eval. Min', TObject(isBiseccionMin));
  metodosList.AddObject('Fal. Pos. Eval. Min', TObject(isFalseMin));
  metodosList.AddObject('falsa pos. mod.', TObject(isModifiedFalse));
  metodoInput.Items.Assign(metodosList);
end;

procedure TForm1.probar(Sender: TObject);
var
  metodo: bracketMethod;
begin
  metodo:= bracketMethod.OnCreate(functionInput.Text, 0,0,5);
  metodo.test(StrToFloat(testInput.text));

end;

end.
