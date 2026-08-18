unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, streamex;

type
  A_Byte = array of Byte;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
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

procedure SaveTextAndIntegerToStream(const AFileName: string; const MyValue: Integer);
var
  FS: TFileStream;
  Txt_:string;
begin
  FS := TFileStream.Create(AFileName, fmCreate);
  try
    Txt_:=#13#10+'[Section1]'+#13#10;
    if Txt_ = '' then Exit;
    FS.WriteBuffer(Pointer(Txt_)^, length(Txt_)); //Save only string no stucture
    FS.WriteBuffer(MyValue, SizeOf(MyValue)); //Save both stucture and value
    FS.Seek(10, soCurrent);
    Txt_:=#13#10+'[Section2]'+#13#10;
    if Txt_ = '' then Exit;
    FS.WriteBuffer(Pointer(Txt_)^, length(Txt_));
    FS.WriteBuffer(MyValue, SizeOf(MyValue));
  finally
    FS.Free;
  end;
end;

procedure LoadFileToBuffer(const FileName: string);
var
  FileStream: TFileStream;
  Buffer: array of Byte; // Dynamic array
begin
  if not FileExists(FileName) then Exit;

  // Open the file in read-only mode
  FileStream := TFileStream.Create(FileName, fmOpenRead);
  try
    if FileStream.Size > 0 then
    begin
      Buffer := Default(A_Byte);
      SetLength(Buffer, FileStream.Size);

      // Read everything directly into the buffer memory reference
      FileStream.ReadBuffer(Buffer[0], FileStream.Size);

      // -- Your processing logic here --
    end;
  finally
    FileStream.Free; // Always free the stream object
  end;
end;

procedure LoadFileInChunks(const FileName: string);
const
  BufferSize = 4096; // 4 KB chunk size
var
  FileStream: TFileStream;
  Buffer: array[0..BufferSize - 1] of Byte; // Fixed-size block
  BytesRead: Integer;
begin
  if not FileExists(FileName) then Exit;

  FileStream := TFileStream.Create(FileName, fmOpenRead);
  try
    while FileStream.Position < FileStream.Size do
    begin
      BytesRead := FileStream.Read(Buffer, BufferSize);

      if BytesRead > 0 then
      begin
        // Process the current block stored in 'Buffer' (up to BytesRead)
      end;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SaveTextAndIntegerToStream('test.bin',120)
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  if Label1 = nil then exit;
  if Label2 = nil then exit;
  Label1.Caption:= '';
  Label2.Caption:= '';
end;

procedure TForm1.Button11Click(Sender: TObject);
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
    Label1.Left:=336;
    Label1.Top:=232;
    Label1.Parent := Form1;
  end;
  if Label2 = nil then
  begin
    Label2 := Tlabel.Create(self);
    Label2.Left:=336;
    Label2.Top:=248;
    Label2.Parent := Form1;
  end;

  if Label1 = nil then exit;
  if Label2 = nil then exit;

  Label1.Caption:='Hello';
  WriteComponentResFile('Label.obj',Label1);
  FreeAndNil(Label1);

  Label2.Caption:='Hello';
  WriteComponentResFile('Labe2.obj',Label2);
  FreeAndNil(Label2);

  if not FileExists('Label.obj') then
  begin
    showmessage('Label.obj not exists');
    Exit;
  end;

  if not FileExists('Labe2.obj') then
  begin
    showmessage('Labe2.obj not exists');
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

  FileStream := TFileStream.Create('Labe2.obj', fmOpenRead);
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
  DeleteFile('Labe2.obj');
end;

procedure TForm1.Button12Click(Sender: TObject);
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
  if Label2 <> nil then FreeAndNil(Label2);

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
          BufferToFile(Buffer_, 'Labe2.obj');
          continue_:=i+Length(Arr1)+4;
          break;
        end;
      end;

    end;

  finally
    FileStream.Free;
  end;

  if (not FileExists('Label.obj')) or (not FileExists('Labe2.obj')) then
  begin
    showmessage({$INCLUDE %LINE%}+': File not exists');
    exit;
  end;

  if Label1 <> nil then FreeAndNil(Label1);
  Label1:= ReadComponentResFile('Label.obj',nil) as Tlabel;
  Label1.Parent := Form1;

  if Label2 <> nil then FreeAndNil(Label2);
  Label2:= ReadComponentResFile('Labe2.obj',nil) as Tlabel;
  Label2.Parent := Form1;

  DeleteFile('Label.obj');
  DeleteFile('Labe2.obj');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  FS: TFileStream;
  MyInteger: Integer;
begin

  if Label1 = nil then
  begin
    Label1 := Tlabel.Create(self);
    Label1.Left:=336;
    Label1.Top:=232;
    Label1.Parent := Form1;
  end;
  if Label2 = nil then
  begin
    Label2 := Tlabel.Create(self);
    Label2.Left:=336;
    Label2.Top:=248;
    Label2.Parent := Form1;
  end;

  if Label1 = nil then exit;
  if Label2 = nil then exit;

  Label1.Caption:='Not found';
  Label2.Caption:='Not found';

  if not FileExists('test.bin') then
  begin
    showmessage('File not exists');
    Exit;
  end;

  MyInteger:=0;
  FS := TFileStream.Create('test.bin', fmOpenRead or fmShareDenyWrite);
  try
    FS.ReadBuffer(MyInteger, SizeOf(MyInteger));
    Label1.Caption:=MyInteger.ToString;
    MyInteger:=0;
    FS.Seek(10, soCurrent);
    FS.ReadBuffer(MyInteger, SizeOf(MyInteger));
    Label2.Caption:=MyInteger.ToString;
  finally
    FS.Free;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Stream: TFileStream;
  List: TStringList;
  FoundIndex: Integer;
begin
  if Label1 = nil then
  begin
    Label1 := Tlabel.Create(self);
    Label1.Left:=336;
    Label1.Top:=232;
    Label1.Parent := Form1;
  end;
  if Label2 = nil then
  begin
    Label2 := Tlabel.Create(self);
    Label2.Left:=336;
    Label2.Top:=248;
    Label2.Parent := Form1;
  end;

  if Label1 = nil then exit;
  if Label2 = nil then exit;

  Label1.Caption:='Not found';
  Label2.Caption:='Not found';

  if not FileExists('test.bin') then
  begin
    showmessage('File not exists');
    Exit;
  end;

  Stream := TFileStream.Create('test.bin', fmOpenRead or fmShareDenyWrite);
  List := TStringList.Create;
  try
    List.LoadFromStream(Stream);
    FoundIndex := List.IndexOf('[Section1]');
    if FoundIndex <> -1 then
      Label1.Caption:= List[FoundIndex+1];
    FoundIndex := List.IndexOf('[Section2]');
    if FoundIndex <> -1 then
      Label2.Caption:= List[FoundIndex+1];
  finally
    List.Free;
    Stream.Free;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  Stream: TFileStream;
  Reader: TStreamReader;
  Line: String;
  //Found: Boolean;
begin
  if Label1 = nil then
  begin
    Label1 := Tlabel.Create(self);
    Label1.Left:=336;
    Label1.Top:=232;
    Label1.Parent := Form1;
  end;
  if Label2 = nil then
  begin
    Label2 := Tlabel.Create(self);
    Label2.Left:=336;
    Label2.Top:=248;
    Label2.Parent := Form1;
  end;

  if Label1 = nil then exit;
  if Label2 = nil then exit;

  Label1.Caption:='Not found';
  Label2.Caption:='Not found';

  if not FileExists('test.bin') then
  begin
    showmessage('File not exists');
    Exit;
  end;

  Stream := TFileStream.Create('test.bin', fmOpenRead or fmShareDenyWrite);
  Reader := TStreamReader.Create(Stream);
  try
    //Found := False;
    while not Reader.Eof do
    begin
      Line := Reader.ReadLine;
      if Pos('[Section1]', Line) > 0 then
      begin
        Line := Reader.ReadLine;
        Label1.Caption:=Line;
      end;
      if Pos('[Section2]', Line) > 0 then
      begin
        Line := Reader.ReadLine;
        Label2.Caption:=Line;
      end;
    end;
  finally
    Reader.Free; // Frees stream if owned, or free separately
    Stream.Free;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  Stream: TFileStream;
  TargetValue, CurrentValue: Integer;
  Found: Boolean;
begin
  if Label1 = nil then
  begin
    Label1 := Tlabel.Create(self);
    Label1.Left:=336;
    Label1.Top:=232;
    Label1.Parent := Form1;
  end;
  if Label2 = nil then
  begin
    Label2 := Tlabel.Create(self);
    Label2.Left:=336;
    Label2.Top:=248;
    Label2.Parent := Form1;
  end;

  if Label1 = nil then exit;
  if Label2 = nil then exit;

  Label1.Caption:='Not found';
  Label2.Caption:='Not found';

  if not FileExists('test.bin') then
  begin
    showmessage('File not exists');
    Exit;
  end;

  CurrentValue := Default(Integer);

  TargetValue := 1633973089; //'asdasd'
  Found := False;
  Stream := TFileStream.Create('test.bin', fmOpenRead or fmShareDenyWrite);
  try
    Stream.Position := 0;
    while Stream.Position < Stream.Size do
    begin
      Stream.ReadBuffer(CurrentValue, SizeOf(Integer));
      if CurrentValue = TargetValue then  //1633973089='asdasd'
      begin
        Found := True;
        Label1.Caption:='Found: asdasd';
        Label2.Caption:=CurrentValue.ToString;
        Break;
      end;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
//const
//  ArraySize = 5;
var
  FileStream: TFileStream;
  Buffer: array of Byte; // Dynamic array
  i:integer;
  Arr1: array of Byte; //Arr1: array[1..ArraySize] of Byte = (1, 2, 3, 4, 5);
  s:string;
  s2:string;
  i2:integer;
begin
  if Label1 = nil then
  begin
    Label1 := Tlabel.Create(self);
    Label1.Left:=336;
    Label1.Top:=232;
    Label1.Parent := Form1;
  end;
  if Label2 = nil then
  begin
    Label2 := Tlabel.Create(self);
    Label2.Left:=336;
    Label2.Top:=248;
    Label2.Parent := Form1;
  end;

  if Label1 = nil then exit;
  if Label2 = nil then exit;

  Label1.Caption:='Not found';
  Label2.Caption:='Not found';

  if not FileExists('test.bin') then
  begin
    showmessage('File not exists');
    Exit;
  end;

  i2 := Default(Integer);
  Arr1:=BytesOf('[Section1]');
  SetString(s, PAnsiChar(@Arr1[0]), Length(Arr1)); //Array of byte to string

  SetLength(Arr1, 0);
  SetLength(Arr1, Length('[Section1]'));

  //showmessage(IntToStr(Length(Arr1))+ ' ' + IntToStr(Length(Arr2)));
  //showmessage(IntToStr(CompareByte(Arr1, Arr2, Length(Arr1))));

  FileStream := TFileStream.Create('test.bin', fmOpenRead);
  try
    if FileStream.Size > 0 then
    begin
      Buffer := Default(A_Byte);
      SetLength(Buffer, FileStream.Size);
      FileStream.ReadBuffer(Buffer[0], FileStream.Size);

      for i := 0 to length(Buffer)-1 do
      begin
        Move(Buffer[i], Arr1[0], Length(Arr1)); //Transfer array of byte to array of byte
        SetString(s2, PAnsiChar(@Arr1[0]), Length(Arr1)); //Array of byte to string
        if s=s2 then
        begin
          Move(Buffer[i+11+1], i2, SizeOf(i2)); //Array of byte to integer
          Label1.Caption:=i2.ToString;
        end;
        if '[Section2]'=s2 then
        begin
          Move(Buffer[i+11+1], i2, SizeOf(i2)); //Array of byte to integer
          Label2.Caption:=i2.ToString;
          break;
        end;
      end;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  FS: TFileStream;
  i:integer;
begin
  i:=120;
  FS := TFileStream.Create('test.bin', fmCreate);
  try
    FS.WriteBuffer(i, SizeOf(i)); //Save both stucture and value
    FS.Seek(10, soCurrent);
    FS.WriteBuffer(i, SizeOf(i));
  finally
    FS.Free;
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  FileStream: TFileStream;
  Buffer: array of Byte; // Dynamic array
  i:integer;
begin
  if Label1 = nil then
  begin
    Label1 := Tlabel.Create(self);
    Label1.Left:=336;
    Label1.Top:=232;
    Label1.Parent := Form1;
  end;
  if Label2 = nil then
  begin
    Label2 := Tlabel.Create(self);
    Label2.Left:=336;
    Label2.Top:=248;
    Label2.Parent := Form1;
  end;

  if Label1 = nil then exit;
  if Label2 = nil then exit;

  Label1.Caption:='Not found';
  Label2.Caption:='Not found';

  if not FileExists('test.bin') then
  begin
    showmessage('File not exists');
    Exit;
  end;

  i := Default(Integer);
  FileStream := TFileStream.Create('test.bin', fmOpenRead);
  try
    if FileStream.Size > 0 then
    begin
      Buffer := Default(A_Byte);
      SetLength(Buffer, FileStream.Size);
      FileStream.ReadBuffer(Buffer[0], FileStream.Size);

      Move(Buffer[0], i, SizeOf(i)); //Array of byte to integer
      Label1.Caption:=i.ToString;

      //0..3 = Stucture of integer
      //+10 = Seek 10 byte
      Move(Buffer[4+10], i, SizeOf(i));
      Label2.Caption:=i.ToString;

    end;
  finally
    FileStream.Free;
  end;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  FileStream: TFileStream;
  AStringList: TStringList;
begin
  AStringList:= TStringList.Create;
  AStringList.Add('asdasd');
  AStringList.Add('123');
  AStringList.Add('[Section1]');
  AStringList.Add('120');
  AStringList.Add('1.235');
  AStringList.Add('[Section2]');
  AStringList.Add('120');
  AStringList.Add('xx');
  FileStream := TFileStream.Create('test.bin', fmCreate);
  try
    AStringList.SaveToStream(FileStream);
  finally
    FileStream.Free;
    AStringList.Free;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Label1 <> nil then FreeAndNil(Label1);
  if Label2 <> nil then FreeAndNil(Label2);
end;

initialization
  RegisterClasses([TForm1,TLabel,TCustomLabel]);

end.
