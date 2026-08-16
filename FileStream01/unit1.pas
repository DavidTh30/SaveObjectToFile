unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, streamex;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
procedure SaveIntegerToStream(const AFileName: string; const MyValue: Integer);
var
  FS: TFileStream;
begin
  // Create or overwrite the file
  FS := TFileStream.Create(AFileName, fmCreate);
  try
    // Pass the variable and its memory size
    FS.WriteBuffer(MyValue, SizeOf(MyValue));   //SizeOf  //length
    FS.Seek(10, soCurrent);
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
  SaveIntegerToStream('test.bin',120)
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  FS: TFileStream;
  MyInteger: Integer;
begin
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
  Stream := TFileStream.Create('document.txt', fmOpenRead or fmShareDenyWrite);
  List := TStringList.Create;
  try
    List.LoadFromStream(Stream);
    FoundIndex := List.IndexOf('SearchText'); // Exact match
    if FoundIndex <> -1 then
      // Text found at line FoundIndex
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
  Stream := TFileStream.Create('document.txt', fmOpenRead or fmShareDenyWrite);
  Reader := TStreamReader.Create(Stream);
  try
    Found := False;
    while not Reader.Eof do
    begin
      Line := Reader.ReadLine;
      if Pos('SearchText', Line) > 0 then
      begin
        Found := True;
        Break;
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
  TargetValue := 12345;
  Found := False;
  Stream := TFileStream.Create('data.bin', fmOpenRead or fmShareDenyWrite);
  try
    Stream.Position := 0;
    while Stream.Position < Stream.Size do
    begin
      Stream.ReadBuffer(CurrentValue, SizeOf(Integer));
      if CurrentValue = TargetValue then
      begin
        Found := True;
        Break;
      end;
    end;
  finally
    Stream.Free;
  end;
end;

end.

