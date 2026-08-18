unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type
  A_Byte = array of Byte;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CmdClear: TButton;
    Image1: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
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
procedure BufferToFile(Buffer_: A_Byte; File_ : string);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(File_, fmCreate);
  try
    FileStream.WriteBuffer(Buffer_[0], length(Buffer_)); //Save both stucture and value
    //showmessage(length(Buffer_).Tostring);
  finally
    FileStream.Free;
  end;

end;

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
  if Label1 = nil then
  begin
    Label1 := Tlabel.Create(self);
    Label1.Left:=182;
    Label1.Top:=120;
    Label1.Caption:='Hello object';
    Label1.Parent := Form1;
  end;
  if Image1 = nil then
  begin
    Image1 := TImage.Create(self);
    Image1.Left:=182;
    Image1.Top:=139;
    Image1.Width:=128;
    Image1.Height:=128;
    Image1.Parent := Form1;
  end;

  if Label1 = nil then exit;
  if Image1 = nil then exit;

  WriteComponentResFile('Label.obj',Label1);
  FreeAndNil(Label1);

  LoadFromImageList(Image1, ImageList1, 0);
  WriteComponentResFile('Image.obj',Image1);
  FreeAndNil(Image1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Label1 <> nil then FreeAndNil(Label1);
  if Image1 <> nil then FreeAndNil(Image1);

  if (not FileExists('Label.obj')) or (not FileExists('Image.obj')) then
  begin
    showmessage('File not exists');
    exit;
  end;

  Label1:= ReadComponentResFile('Label.obj',nil) as Tlabel;
  Label1.Parent := Form1;

  Image1:= ReadComponentResFile('Image.obj',nil) as TImage;
  Image1.Parent := Form1;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if Label1 <> nil then FreeAndNil(Label1);
  if Image1 <> nil then FreeAndNil(Image1);

  if (not FileExists('Label.obj')) or (not FileExists('Image.obj')) then
  begin
    showmessage('File not exists');
    exit;
  end;

  Label1:= Tlabel(ReadComponentResFile('Label.obj',nil));
  Label1.Parent := Form1;

  Image1:= TImage(ReadComponentResFile('Image.obj',nil));
  Image1.Parent := Form1;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if Label1 <> nil then FreeAndNil(Label1);
  if Image1 <> nil then FreeAndNil(Image1);

  if (not FileExists('Label.obj')) or (not FileExists('Image.obj')) then
  begin
    showmessage('File not exists');
    exit;
  end;

  Label1:=TLabel(ReadComponentResFile('Label.obj',TLabel.Create(self)));
  Label1.Parent := Form1;

  Image1:=TImage(ReadComponentResFile('Image.obj',TImage.Create(self)));
  Image1.Parent := Form1;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  FileStream: TFileStream;
  Buffer1: array of Byte; // Dynamic array
  Buffer2: array of Byte; // Dynamic array
  Txt_:string;
  MyValue:integer;
begin
  if Label1 = nil then
  begin
    Label1 := Tlabel.Create(self);
    Label1.Left:=182;
    Label1.Top:=120;
    Label1.Caption:='Hello object';
    Label1.Parent := Form1;
  end;
  if Image1 = nil then
  begin
    Image1 := TImage.Create(self);
    Image1.Left:=182;
    Image1.Top:=139;
    Image1.Width:=128;
    Image1.Height:=128;
    Image1.Parent := Form1;
  end;

  if Label1 = nil then exit;
  if Image1 = nil then exit;

  WriteComponentResFile('Label.obj',Label1);
  FreeAndNil(Label1);

  LoadFromImageList(Image1, ImageList1, 0);
  WriteComponentResFile('Image.obj',Image1);
  FreeAndNil(Image1);

  if not FileExists('Label.obj') then
  begin
    showmessage('Label.obj not exists');
    Exit;
  end;

  if not FileExists('Image.obj') then
  begin
    showmessage('Image.obj not exists');
    Exit;
  end;

  FileStream := TFileStream.Create('Label.obj', fmOpenRead);
  try
    if FileStream.Size > 0 then
    begin
      Buffer1 := Default(A_Byte);
      SetLength(Buffer1, FileStream.Size);
      FileStream.ReadBuffer(Buffer1[0], FileStream.Size);
    end;
  finally
    FileStream.Free;
  end;

  FileStream := TFileStream.Create('Image.obj', fmOpenRead);
  try
    if FileStream.Size > 0 then
    begin
      Buffer2 := Default(A_Byte);
      SetLength(Buffer2, FileStream.Size);
      FileStream.ReadBuffer(Buffer2[0], FileStream.Size);
    end;
  finally
    FileStream.Free;
  end;

  FileStream := TFileStream.Create('test.bin', fmCreate);
  try
    FileStream.Seek(10, soCurrent);
    Txt_:='[Object1]';
    MyValue:=length(Buffer1);
    FileStream.WriteBuffer(Pointer(Txt_)^, length(Txt_)); //Save only string no stucture
    FileStream.WriteBuffer(MyValue, SizeOf(MyValue)); //Save both stucture and value
    FileStream.WriteBuffer(Buffer1[0], length(Buffer1)); //Save both stucture and value
    //showmessage(length(Buffer1).ToString);

    FileStream.Seek(10, soCurrent);
    Txt_:='[Object2]';
    MyValue:=length(Buffer2);
    FileStream.WriteBuffer(Pointer(Txt_)^, length(Txt_)); //Save only string no stucture
    FileStream.WriteBuffer(MyValue, SizeOf(MyValue)); //Save both stucture and value
    FileStream.WriteBuffer(Buffer2[0], length(Buffer2));
  finally
    FileStream.Free;
  end;

  DeleteFile('Label.obj');
  DeleteFile('Image.obj');
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  FileStream: TFileStream;
  Buffer: array of Byte; // Dynamic array
  Buffer_: A_Byte; // Dynamic array
  Arr1: array of Byte; //Arr1: array[1..ArraySize] of Byte = (1, 2, 3, 4, 5);
  s2:string;
  i:integer;
  ObjectSize:integer;
  continue_:integer;
begin
  if Label1 <> nil then FreeAndNil(Label1);
  if Image1 <> nil then FreeAndNil(Image1);

  if not FileExists('test.bin') then
  begin
    showmessage({$INCLUDE %LINE%}+': File not exists');
    Exit;
  end;

  ObjectSize := Default(Integer);
  Arr1:=BytesOf('[Object1]');
  //SetString(s, PAnsiChar(@Arr1[0]), Length(Arr1)); //Array of byte to string

  FileStream := TFileStream.Create('test.bin', fmOpenRead);
  try
    if FileStream.Size > 0 then
    begin

      Buffer := Default(A_Byte);
      SetLength(Buffer, FileStream.Size);
      FileStream.ReadBuffer(Buffer[0], FileStream.Size);

      continue_:=0;
      for i := 0 to length(Buffer)-1 do
      begin
        Move(Buffer[i], Arr1[0], Length(Arr1)); //Transfer array of byte to array of byte
        SetString(s2, PAnsiChar(@Arr1[0]), Length(Arr1)); //Array of byte to string
        if '[Object1]'=s2 then
        begin
          Move(Buffer[i+Length(Arr1)], ObjectSize, SizeOf(ObjectSize)); //Array of byte to integer
          //showmessage(ObjectSize.ToString);
          Buffer_ := Default(A_Byte);
          SetLength(Buffer_, ObjectSize);
          Move(Buffer[i+Length(Arr1)+4], Buffer_[0], ObjectSize);
          BufferToFile(Buffer_, 'Label.obj');
          continue_:=i+Length(Arr1)+4;
          break;
        end;
      end;

      if continue_ > 0 then;
      for i := continue_ to length(Buffer)-1 do
      begin
        Move(Buffer[i], Arr1[0], Length(Arr1)); //Transfer array of byte to array of byte
        SetString(s2, PAnsiChar(@Arr1[0]), Length(Arr1)); //Array of byte to string
        if '[Object2]'=s2 then
        begin
          Move(Buffer[i+Length(Arr1)], ObjectSize, SizeOf(ObjectSize)); //Array of byte to integer
          //showmessage(ObjectSize.ToString);
          Buffer_ := Default(A_Byte);
          SetLength(Buffer_, ObjectSize);
          Move(Buffer[i+Length(Arr1)+4], Buffer_[0], ObjectSize);
          BufferToFile(Buffer_, 'Image.obj');
          continue_:=i+Length(Arr1)+4;
          break;
        end;
      end;

    end;

  finally
    FileStream.Free;
  end;

  if (not FileExists('Label.obj')) or (not FileExists('Image.obj')) then
  begin
    showmessage({$INCLUDE %LINE%}+': File not exists');
    exit;
  end;

  if Label1 <> nil then FreeAndNil(Label1);
  Label1:= ReadComponentResFile('Label.obj',nil) as Tlabel;
  Label1.Parent := Form1;

  if Image1 <> nil then FreeAndNil(Image1);
  Image1:= ReadComponentResFile('Image.obj',nil) as TImage;
  Image1.Parent := Form1;

  DeleteFile('Label.obj');
  DeleteFile('Image.obj');
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

