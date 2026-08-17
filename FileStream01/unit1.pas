unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, streamex;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button10: TButton;
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
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
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
      // Allocate the exact size of the file to the buffer
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
    // Keep reading until the end of the file stream is reached
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
  Label1.Caption:= '';
  Label2.Caption:= '';
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  FS: TFileStream;
  MyInteger: Integer;
begin

  Label1.Caption:='Not found';
  Label1.Caption:='Not found';

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

  Label1.Caption:='Not found';
  Label1.Caption:='Not found';

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
  Found: Boolean;
begin
  Label1.Caption:='Not found';
  Label1.Caption:='Not found';

  if not FileExists('test.bin') then
  begin
    showmessage('File not exists');
    Exit;
  end;

  Stream := TFileStream.Create('test.bin', fmOpenRead or fmShareDenyWrite);
  Reader := TStreamReader.Create(Stream);
  try
    Found := False;
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
  Label1.Caption:='Not found';
  Label1.Caption:='Not found';

  if not FileExists('test.bin') then
  begin
    showmessage('File not exists');
    Exit;
  end;

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
const
  ArraySize = 5;
var
  FileStream: TFileStream;
  Buffer: array of Byte; // Dynamic array
  i:integer;
  Arr1: array of Byte; //Arr1: array[1..ArraySize] of Byte = (1, 2, 3, 4, 5);
  s:string;
  s2:string;
  i2:integer;
begin

  Label1.Caption:='Not found';
  Label1.Caption:='Not found';

  if not FileExists('test.bin') then
  begin
    showmessage('File not exists');
    Exit;
  end;

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

  Label1.Caption:='Not found';
  Label1.Caption:='Not found';

  if not FileExists('test.bin') then
  begin
    showmessage('File not exists');
    Exit;
  end;

  FileStream := TFileStream.Create('test.bin', fmOpenRead);
  try
    if FileStream.Size > 0 then
    begin
      SetLength(Buffer, FileStream.Size);
      FileStream.ReadBuffer(Buffer[0], FileStream.Size);

      Move(Buffer[0], i, SizeOf(i)); //Array of byte to integer
      Label1.Caption:=i.ToString;

      //0..3 = Stucture of integer
      //+10 = Seek 10 byte
      //+1 = start next Stucture of integer
      Move(Buffer[3+10+1], i, SizeOf(i));
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

end.

