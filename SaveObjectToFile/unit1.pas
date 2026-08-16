unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1_: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public

  end;

var
  Form1: TForm1;
  Label3:Tlabel;

implementation

{$R *.lfm}

{ TForm1 }
procedure SaveComponentToFile(AComponent: TComponent; const AFileName: string);
begin
  // Automatically serializes the component and its published properties
  WriteComponentResFile(AFileName, AComponent);
end;

function LoadComponentFromFile(const AFileName: string): TComponent;
begin
  if not FileExists(AFileName) then showmessage('File not exists');
  if FileExists(AFileName) then
  Result := ReadComponentResFile(AFileName, nil);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Label2:TComponent;
begin
  Label2:=TComponent.Create(nil);
  //WriteComponentResFile('123.obj',Label1_);  //Not work
  WriteComponentResFile('123.obj',Label1_);
  //WriteComponentResFile('123.obj',Label2 as TComponent );
  FreeAndNil(Label2);
  FreeAndNil(Label1_);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Label3 <> nil then exit;
  Label3:= ReadComponentResFile('123.obj',nil) as Tlabel;
  Label3.Parent := Form1;
  //Label3.Visible:=true;
  //Label3.Top:=5;
  //Label3.Left:=5;
  //showmessage(Label3.Name+ ' '+ Label3.Caption);
  //Label2:=Tlabel(TComponent);
  //Label2:=Tlabel.Create(self);
  //FreeAndNil(Label3);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Label2:TComponent;
begin
  Label2:= ReadComponentResFile('123.obj',nil).Create(nil);
  FreeAndNil(Label2);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  Label2:TCustomLabel;
begin
  Label2:=TLabel(ReadComponentResFile('123.obj',nil)).Create(nil);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Label3 <> nil then FreeAndNil(Label3);
end;

initialization
  RegisterClasses([TForm1,Tlabel]);

end.

