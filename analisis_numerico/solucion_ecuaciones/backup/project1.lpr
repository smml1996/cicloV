program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, Math
  { you can add units after this };


type

  { Ejercicio }

  Ejercicio = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ Ejercicio }

function getTruePercentRelativeError(trueError: Single):Single ;
begin
  Result:=  trueError/ (power(Pi,4)/90) * 100;
end;

function getTrueError(aprox:Single):Single;
begin
  Result:= (power(Pi,4)/90) - aprox;
end;

procedure Ejercicio.DoRun;
var
  ErrorMsg: String;
  n: Integer;
  aproximation:Single;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  aproximation:=0;
  n:=1;
  while n<=10000 do
  begin
     aproximation:= aproximation+ power(n,-4);
     n:=n+1;
  end;

  writeln(getTruePercentRelativeError(getTrueError(aproximation)));

  n:=10000;
  aproximation:=0;
  while n>0 do
  begin
    aproximation:= aproximation + 1/power(n, -4);
    n:=n-1;

  end;
  writeLn(getTruePercentRelativeError(getTrueError(aproximation)));
  { add your program here }



  // stop program loop
  Terminate;
end;

constructor Ejercicio.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor Ejercicio.Destroy;
begin
  inherited Destroy;
end;

procedure Ejercicio.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: Ejercicio;
begin
  Application:=Ejercicio.Create(nil);
  Application.Title:='Ejercicios';
  Application.Run;
  Application.Free;
end.

