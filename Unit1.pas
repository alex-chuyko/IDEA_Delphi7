unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan;

type
  TForm1 = class(TForm)
    btn1: TButton;
    mmo1: TMemo;
    rb1: TRadioButton;
    rb2: TRadioButton;
    btn2: TButton;
    btn3: TButton;
    lbl1: TLabel;
    lbl2: TLabel;
    xpmnfst1: TXPManifest;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  arrWord = array[0..10, 1..4] of word;
  arrKey = array[1..9, 1..8] of word;
  arrKey1 = array[1..9, 1..6] of word;
  arrByte = array[0..9, 1..8] of byte;

var
  Form1: TForm1;
  FileNameKey, FileNameText: string;
  flagKey, flagText, flag : boolean;

implementation

{$R *.dfm}

procedure BinToInt(str : string; var arr: arrKey; shift : integer);
var
  d, i, j, k: integer;
  res : word;
begin
  d := 1;
  res := 0;
  k := 8;
  while Length(str) > 0 do
  begin
    for i:= length(str) downto length(str) - 15 do
    begin
      if str[i] = '1' then
      begin
        for j:= 1 to length(str) - i do
          d:= d * 2;
        res := res + d;
        d := 1;
      end;
    end;
    arr[shift, k] := res;
    dec(k);
    res := 0;
    delete(str, length(str) - 15, 16);
  end;
end;

function IntToBin(a: word): string;
var
  temp : byte;
  str : string;
  counter, i : integer;
begin
  str := '';
  counter := 0;
  while (a <> 0) do
  begin
    inc(counter);
    temp := a mod 2;
    str := IntToStr(temp) + str;
    a := a div 2;
  end;
  if counter < 16 then
    for i:=1 to (16 - counter) do
      str := '0' + str;
  IntToBin := str;
end;

function rol(str : string; shift: integer): string;
var
  strTemp : string;
begin
  strTemp := copy(str, 1, shift);
  delete(str, 1, shift);
  str := str + strTemp;
  rol := str;
end;

function sumMod(a, b : integer): word;
begin
  result := (a + b) mod 65536;
end;

function multiMod(a, b : longword): word;
begin
  if (a = 0) and (b = 0) then
    result := 1
  else
  begin
    if a = 0 then
      a := 65536;
    if b = 0 then
      b := 65536;
    result := (a * b) mod 65537;
  end;
end;

procedure raund(i: integer; var arr: arrWord; key : arrKey1);
var
  a, b, c, d, e, f: word;
begin
  if i < 9 then
  begin
    a := multiMod(arr[i-1, 1], key[i, 1]);
    b := sumMod(arr[i-1, 2], key[i, 2]);
    c := sumMod(arr[i-1, 3], key[i, 3]);
    d := multiMod(arr[i-1, 4], key[i, 4]);
    e := a xor c;
    f := b xor d;
    arr[i, 1] := a xor multiMod(sumMod(f, multiMod(e, key[i, 5])),key[i, 6]);
    arr[i, 2] := c xor multiMod(sumMod(f, multiMod(e, key[i, 5])),key[i, 6]);
    arr[i, 3] := b xor sumMod(multiMod(e, key[i, 5]), multiMod(sumMod(f, multiMod(e, key[i ,5])), key[i, 6]));
    arr[i, 4] := d xor sumMod(multiMod(e, key[i, 5]), multiMod(sumMod(f, multiMod(e, key[i ,5])), key[i, 6]));
  end
  else
    begin
      arr[i, 1] := multiMod(arr[i-1, 1], key[i, 1]);
      arr[i, 2] := sumMod(arr[i-1, 3], key[i, 2]);
      arr[i, 3] := sumMod(arr[i-1, 2], key[i, 3]);
      arr[i, 4] := multiMod(arr[i-1, 4], key[i, 4]);
    end;
end;

function SwapW(i: Word): Word;
begin
  asm
    mov ax, [i]
    xchg al,ah
    mov [i], ax
  end;
  SwapW := i;
end;

procedure generKeyEncryption(var k1 : arrKey1);
var
  i, j, counter, l, k : integer;
  F_in : File of word;
  key : arrKey;
  str : string;
begin
  if flagKey then
  begin
    flag := true;
    AssignFile(F_in, FileNameKey);
    reset(F_in);
    for i:= 1 to 8 do
    begin
      if (Eof(F_in)) and (i = 1) then
      begin
        flag := false;
        ShowMessage('Error!');
        Break;
      end
      else
        begin
          read(F_in, key[1, i]);
          key[1, i] := SwapW(key[1, i]);
        end;
    end;
    CloseFile(F_in);

    for j:= 2 to 9 do
    begin
      str := '';
      for i:= 1 to 8 do
        str := str + IntToBin(key[j-1, i]);
      str := rol(str, 25);
      BinToInt(str, key, j);
    end;

    l := 1; k := 1; counter := 0;
    while k <= 8 do
    begin
      inc(counter);
      for j:= 1 to 8 do
      begin
        k1[k, l] := key[counter, j];
        if l = 6 then
        begin
          inc(k);
          l := 0;
        end;
        inc(l);
      end;
    end;

    for i:= 1 to 4 do
      k1[k, i] := key[counter + 1, i];
  end;
end;

function multInv(a : longword): word;
var
  i : longword;
begin
  if a = 0 then
    a := 65536;
  for i:= 1 to 65536 do
  begin
    if i = 65536 then
      multInv := 0
    else
    if ((a * i) mod 65537) = 1 then
    begin
      multInv := i;
      break;
    end;
  end;
end;

function addInv(a : word): word;
begin
  addInv := 65536 - a;
end;

procedure generKeyDecryption(var k1 : arrKey1; key : arrKey1);
var
  i: integer;
begin
  for i:=1 to 9 do
  begin
    if (i = 1) or (i = 9) then
    begin
      k1[i, 1] := multInv(key[10-i, 1]);
      k1[i, 2] := addInv(key[10-i, 2]);
      k1[i, 3] := addInv(key[10-i, 3]);
      k1[i, 4] := multInv(key[10-i, 4]);
      if i = 1 then
      begin
        k1[i, 5] := key[9-i, 5];
        k1[i, 6] := key[9-i, 6];
      end;
    end
    else
      begin
        k1[i, 1] := multInv(key[10-i, 1]);
        k1[i, 2] := addInv(key[10-i, 3]);
        k1[i, 3] := addInv(key[10-i, 2]);
        k1[i, 4] := multInv(key[10-i, 4]);
        k1[i, 5] := key[9-i, 5];
        k1[i, 6] := key[9-i, 6];
      end;
  end;
end;

procedure ByteToWord(arr1: arrByte; var arr : arrWord);
var
  i, j: integer;
begin
  i:= 1; j := 1;
  while i <= 8 do
  begin
    arr[0, j] := 0;
    arr[0, j] := arr1[0, i] shl 8 + arr1[0, i+1];
    i := i + 2;
    inc(j);
  end;
end;

procedure WordToByte(a : word; var b, c: byte);
var
  temp : word;
begin
  c := 0;
  b := 0;
  temp := 0;
  temp := a shl 8;
  b := temp shr 8;
  c := a shr 8;
end;

procedure encryption(k1 : arrKey1);
var
  f: File of byte;
  arr : arrWord;
  i: integer;
  OutFileName: string;
  b, c : byte;
  arr1 : arrByte;
begin
  b := 0;
  c := 0;
  arr[10, 1] := 0;
  if flagText then
  begin
    OutFileName := FileNameText + '.encr';
    AssignFile(output, OutFileName);
    rewrite(output);
    AssignFile(f, FileNameText);
    reset(f);
    while not Eof(f) do
    begin
      for i:= 1 to 8 do
      begin
        arr1[0, i] := 0;
        if not Eof(f) then
          read(f, arr1[0, i])
        else
          inc(arr[10, 1]);
      end;

      ByteToWord(arr1, arr);

      for i:= 1 to 9 do
        raund(i, arr, k1);

      for i:=1 to 4 do
      begin
        WordToByte(arr[9, i], b, c);
        write(chr(c), chr(b));
        //write(IntToHex(arr[9, i], 4) , ' ');
      end;
    end;
    write(arr[10, 1]);
    CloseFile(output);
    CloseFile(f);
  end;
end;

procedure decryption(k1: arrKey1);
var
  f: File of byte;
  arr : arrWord;
  i: integer;
  OutFileName: string;
  b, c : byte;
  arr1 : arrByte;
begin
  b := 0;
  c := 0;
  arr[10, 1] := 0;
  if flagText then
  begin
    OutFileName := FileNameText + '.decr';
    AssignFile(output, OutFileName);
    rewrite(output);

      AssignFile(f, FileNameText);
      reset(f);
      {$I-}
      while not Eof(f) do
        read(f, arr1[0,1]);
      arr[10, 1] := StrToInt(chr(arr1[0, 1]));
      CloseFile(f);
      {$I+}
    AssignFile(f, FileNameText);
    reset(f);
    read(f, arr1[0, 1]);
    
    while not Eof(f) do
    begin
      for i:= 2 to 8 do
      begin
        arr1[0, i] := 0;
        if not Eof(f) then
          read(f, arr1[0, i]);
      end;

      ByteToWord(arr1, arr);

      for i:= 1 to 9 do
        raund(i, arr, k1);

      read(f, arr1[0,1]);

      if (Eof(f)) then
      begin
        if arr[10, 1] mod 2 = 0 then
        begin
          for i:=1 to (4 - arr[10,1] div 2) do
          begin
            WordToByte(arr[9, i], b, c);
            write(chr(c), chr(b));
            //write(IntToHex(arr[9, i], 4) , ' ');
          end;
        end
        else
          begin
            for i:=1 to (4 - arr[10,1] div 2) do
            begin
              WordToByte(arr[9, i], b, c);
              if i <> (4 - arr[10,1] div 2) then
                write(chr(c), chr(b))
              else
                write(chr(c));
              //write(IntToHex(arr[9, i], 4) , ' ');
            end;
          end;
      end
      else
        begin
          for i:=1 to 4 do
          begin
            WordToByte(arr[9, i], b, c);
            write(chr(c), chr(b));
            //write(IntToHex(arr[9, i], 4) , ' ');
          end;
        end;

     end;
    CloseFile(output);
    CloseFile(f);
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
var
  k1 : arrKey1;
begin
  if rb1.Checked then
  begin
    generKeyEncryption(k1);
    if flag then
    begin
      encryption(k1);
      mmo1.Text := mmo1.text + 'File encryption is complete!' + #13#10;
    end;
  end
  else
  if rb2.Checked then
  begin
    generKeyEncryption(k1);
    if flag then
    begin
      generKeyDecryption(k1, k1);
      decryption(k1);
      mmo1.Text := mmo1.text + 'File decryption is complete!' + #13#10;
    end;
  end;
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  openDialog : TOpenDialog;
begin
  mmo1.Clear;
  flagText:= True;
  openDialog := TOpenDialog.Create(openDialog);
  openDialog.Title:= 'Выберите файл для открытия';
  openDialog.InitialDir := GetCurrentDir;
  openDialog.Options := [ofFileMustExist];
  openDialog.Filter := 'All file|*.*';
  openDialog.FilterIndex := 1;
  if openDialog.Execute then
  begin
    FileNameText:= openDialog.FileName;
  end
  else
    begin
      Application.MessageBox('Выбор файла для открытия остановлен!', 'Предупреждение!');
      flagText:=False;
    end;
  openDialog.Free;

  lbl1.Caption := FileNameText;
end;

procedure TForm1.btn3Click(Sender: TObject);
var
  openDialog: TOpenDialog;
begin
  mmo1.Clear;
  flagKey:= True;
  openDialog := TOpenDialog.Create(openDialog);
  openDialog.Title:= 'Выберите файл для открытия';
  openDialog.InitialDir := GetCurrentDir;
  openDialog.Options := [ofFileMustExist];
  openDialog.Filter := 'Key file|*.bin';
  openDialog.FilterIndex := 1;
  if openDialog.Execute then
  begin
    FileNameKey:= openDialog.FileName;
  end
  else
    begin
      Application.MessageBox('Выбор файла для открытия остановлен!', 'Предупреждение!');
      flagKey:=False;
    end;
  openDialog.Free;

  lbl2.Caption := FileNameKey;
end;

end.
