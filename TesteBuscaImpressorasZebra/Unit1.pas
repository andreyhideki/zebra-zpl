unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.WinSpool, Vcl.Printers, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    PrintDialog1: TPrintDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  //aa
  //Get_NomeDaImpressoraCompartilhada('','','','',True);
end;

function Get_NomeDaImpressoraCompartilhada(Var vServerName, vPrinterName, vShareName, vPorta:String; Var vRede:Boolean):String;
var PrinterInfo: PPrinterInfo2;
    PrnHandle :THandle;
    PrnInfo2 :PPRINTERINFO2;
    PrnInfoSize :DWord;

    pDevice : pChar;
    pDriver : pChar;
    pPort : pChar;
    hDMode : THandle;

    PrintDialog1: TPrintDialog;
Begin
    Result := '';
    vServerName := '';   //na rede "\\192.168.0.157" compart. local retorna nil
    vPrinterName:= '';   //na rede "\\192.168.0.157\EpsonLX-300"
    vShareName  := '';   //na rede "LX-300"
    vRede       := false;
    vPorta      := '';
    printDialog1 := TPrintDialog.Create(nil);

    If printDialog1.Execute Then begin
       if OpenPrinter(PChar(Printer.Printers.Strings[Printer.PrinterIndex]), PrnHandle, nil) then begin
          GetMem(pDevice, cchDeviceName);
          GetMem(pDriver, MAX_PATH);
          GetMem(pPort, MAX_PATH);
          Printer.GetPrinter(pDevice, pDriver, pPort, hDMode);
          if lStrLen(pDriver) = 0 then begin
             GetProfileString('Devices', pDevice, '', pDriver, MAX_PATH);
             pDriver[pos(',', pDriver) - 1] := #0;
          end;
          if lStrLen(pPort) = 0 then begin
             GetProfileString('Devices', pDevice, '', pPort, MAX_PATH);
             lStrCpy(pPort, @pPort[lStrLen(pPort)+2]);
          end;
          vPorta := StrPas(pPort);

          GetPrinter(PrnHandle, 2, nil, 0, @PrnInfoSize);
          PrnInfo2 := AllocMem(PrnInfoSize);
          if GetPrinter(PrnHandle, 2, PrnInfo2, PrnInfoSize, @PrnInfoSize) then Begin
             Result := PrnInfo2^.pShareName;
             vServerName:= PrnInfo2^.pServerName;
             vPrinterName:= PrnInfo2^.pPrinterName;
             vShareName := PrnInfo2^.pShareName;
             If Pos('\\',vServerName) > 0 Then
                vRede := true;
          End else
             Application.MessageBox('Erro ao conectar Impressora!','Erro',MB_Ok+mb_IconInformation);
          ClosePrinter(PrnHandle);
          FreeMem(PrnInfo2, PrnInfoSize)
       end;
    end;
    printDialog1.Free;
End;

procedure TForm1.FormShow(Sender: TObject);
var PrinterInfo: PPrinterInfo2;
    PrnHandle :THandle;
    PrnInfo2 :PPRINTERINFO2;
    PrnInfoSize :DWord;

    pDevice : pChar;
    pDriver : pChar;
    pPort : pChar;
    hDMode : THandle;

    vPorta,
    resultado,
    vServerName,
    vPrinterName,
    vShareName: string;
    vRede : Boolean;

begin

  If printDialog1.Execute Then begin
     if OpenPrinter(PChar(Printer.Printers.Strings[Printer.PrinterIndex]), PrnHandle, nil) then begin
        GetMem(pDevice, cchDeviceName);
        GetMem(pDriver, MAX_PATH);
        GetMem(pPort, MAX_PATH);
        Printer.GetPrinter(pDevice, pDriver, pPort, hDMode);
        if lStrLen(pDriver) = 0 then begin
           GetProfileString('Devices', pDevice, '', pDriver, MAX_PATH);
           pDriver[pos(',', pDriver) - 1] := #0;
        end;
        if lStrLen(pPort) = 0 then begin
           GetProfileString('Devices', pDevice, '', pPort, MAX_PATH);
           lStrCpy(pPort, @pPort[lStrLen(pPort)+2]);
        end;
        vPorta := StrPas(pPort);

        GetPrinter(PrnHandle, 2, nil, 0, @PrnInfoSize);
        PrnInfo2 := AllocMem(PrnInfoSize);
        if GetPrinter(PrnHandle, 2, PrnInfo2, PrnInfoSize, @PrnInfoSize) then Begin
           resultado := PrnInfo2^.pShareName;
           vServerName:= PrnInfo2^.pServerName;
           vPrinterName:= PrnInfo2^.pPrinterName;
           vShareName := PrnInfo2^.pShareName;
           If Pos('\\',vServerName) > 0 Then
              vRede := true;
        End else
           Application.MessageBox('Erro ao conectar Impressora!','Erro',MB_Ok+mb_IconInformation);
        ShowMessage('resultado: '+resultado);
        ShowMessage('vServerName: '+vServerName);
        ShowMessage('vPrinterName: '+vPrinterName);
        ShowMessage('vShareName: '+vShareName);
        ClosePrinter(PrnHandle);
        FreeMem(PrnInfo2, PrnInfoSize)
     end;
  end;
  printDialog1.Free;
end;

end.
