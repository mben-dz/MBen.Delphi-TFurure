unit Main.View;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls;

type
  TMainView = class(TForm)
    BtnWaitOutsideMainThread: TButton;
    BtnStartWithHelper: TButton;
    BtnWrongUse: TButton;
    BtnMonitorSolution: TButton;
    BtnSimulateIFuture: TButton;
    MemoReply: TMemo;
    BtnClear: TButton;
    procedure BtnWaitOutsideMainThreadClick(Sender: TObject);
    procedure BtnStartWithHelperClick(Sender: TObject);
    procedure BtnWrongUseClick(Sender: TObject);
    procedure BtnMonitorSolutionClick(Sender: TObject);
    procedure BtnSimulateIFutureClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
  private
    procedure LogReply(const aValue: string);

  public

  end;

implementation
uses
  System.Threading, API.Helpers;

{$R *.dfm}

procedure TMainView.LogReply(const aValue: string);
begin
  MemoReply.Lines.Add(aValue);
end;

procedure TMainView.BtnClearClick(Sender: TObject);
begin
  MemoReply.Clear;
  MemoReply.Lines.Add('Future Reply goes Here:');
end;

procedure TMainView.BtnWrongUseClick(Sender: TObject);
var
  LFutureValue: IFuture<string>;
begin
  LFutureValue := TTask.Future<string>(function: string
  begin
    Sleep(3000);
    Result := TimeToStr(Now) + 'تم التنفيذ بهذا الوقت : ✅';
  end);

  LogReply(LFutureValue.Value);
end;

procedure TMainView.BtnSimulateIFutureClick(Sender: TObject);
var
  LResult: string;
  LFuture: ITask;
begin
  LFuture:= TTask.Run(
    procedure
    begin
      Sleep(2000);
      LResult := TimeToStr(Now) + 'تم التنفيذ بهذا الوقت : ✅';

    end);

  TTask.Run(procedure begin

    LFuture.Wait();

    TThread.Queue(nil, procedure begin
      LogReply(LResult);
      LFuture := nil;
    end);
  end);

end;

procedure TMainView.BtnMonitorSolutionClick(Sender: TObject);
begin
  var LFutureValue := TTask.Future<string>(function: string
  begin
    Sleep(3000);
    Result := TimeToStr(Now) + 'تم التنفيذ بهذا الوقت : ✅';
  end);

  TTask.Run(procedure
  var
    LReply: string;
  begin
    LReply := LFutureValue.Value;

    TThread.Queue(TThread.Current, procedure begin
      LogReply(LReply);
    end);

//    while not (LFutureValue.Status in
//      [TTaskStatus.Completed, TTaskStatus.Canceled, TTaskStatus.Exception]) do
//      TThread.Sleep(100);

//    TThread.Queue(nil, procedure begin
//      if LFutureValue.Status = TTaskStatus.Completed then
//        LogReply(LFutureValue.Value) else
//        LogReply('Future Failled or Canceled !!');
//    end);
  end);
end;

procedure TMainView.BtnWaitOutsideMainThreadClick(Sender: TObject);
var
  LFuture: IFuture<Integer>;
begin
  LFuture := TTask.Future<Integer>(
    function: Integer
    begin
      Sleep(3000);
      Result := 42;
    end);

  TTask.Run(
    procedure
    var
      LValue: Integer;
    begin
      LValue := LFuture.Value; // Block or wait inside background thread

      TThread.Queue(nil,
        procedure
        begin
          LogReply('Result is ' + LValue.ToString); // update UI on main thread
          LFuture := nil;
        end);
    end);
end;

procedure TMainView.BtnStartWithHelperClick(Sender: TObject);
begin
  TSimpleFuture<string>.RunFuture(function: string begin
    Sleep(2000);
    Result := TimeToStr(Now) + 'تم التنفيذ بهذا الوقت : ✅';
  end, LogReply);
end;

end.
