unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CmdClear: TButton;
    Image1: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CmdClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public

  end;

var
  Form1: TForm1;

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

procedure LoadFromImageList(AImage: TImage; AList: TImageList; ImgIdx: Integer);
begin
  if (AList <> nil) and (ImgIdx >= 0) and (ImgIdx < AList.Count) then
    AList.GetBitmap(ImgIdx, AImage.Picture.Bitmap) // Directly populates the target image
  else
    AImage.Picture.Clear; // Clears the image if the index doesn't exist
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if Label1 = nil then exit;
  WriteComponentResFile('Label.obj',Label1);
  FreeAndNil(Label1);

  if Image1 = nil then exit;
  LoadFromImageList(Image1, ImageList1, 0);
  WriteComponentResFile('Image.obj',Image1);
  FreeAndNil(Image1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if (not FileExists('Label.obj')) or (not FileExists('Image.obj')) then
  begin
    showmessage('File not exists');
    exit;
  end;

  if Label1 <> nil then FreeAndNil(Label1);
  Label1:= ReadComponentResFile('Label.obj',nil) as Tlabel;
  Label1.Parent := Form1;

  if Image1 <> nil then FreeAndNil(Image1);
  Image1:= ReadComponentResFile('Image.obj',nil) as TImage;
  Image1.Parent := Form1;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if (not FileExists('Label.obj')) or (not FileExists('Image.obj')) then
  begin
    showmessage('File not exists');
    exit;
  end;

  if Label1 <> nil then FreeAndNil(Label1);
  Label1:= Tlabel(ReadComponentResFile('Label.obj',nil));
  Label1.Parent := Form1;

  if Image1 <> nil then FreeAndNil(Image1);
  Image1:= TImage(ReadComponentResFile('Image.obj',nil));
  Image1.Parent := Form1;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if (not FileExists('Label.obj')) or (not FileExists('Image.obj')) then
  begin
    showmessage('File not exists');
    exit;
  end;

  if Label1 <> nil then FreeAndNil(Label1);
  Label1:=TLabel(ReadComponentResFile('Label.obj',TLabel.Create(self)));
  Label1.Parent := Form1;

  if Image1 <> nil then FreeAndNil(Image1);
  Image1:=TImage(ReadComponentResFile('Image.obj',TImage.Create(self)));
  Image1.Parent := Form1;
end;

procedure TForm1.CmdClearClick(Sender: TObject);
begin
  if Label1 <> nil then FreeAndNil(Label1);
  if Image1 <> nil then FreeAndNil(Image1);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Label1 <> nil then FreeAndNil(Label1);
  if Image1 <> nil then FreeAndNil(Image1);
end;

initialization
  RegisterClasses([TForm1,TLabel,TCustomLabel,TImage]);

end.

