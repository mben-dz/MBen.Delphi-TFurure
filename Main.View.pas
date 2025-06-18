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
    Result := '✅ Executed at this time:' + TimeToStr(Now);
  end);

  LogReply(LFutureValue.Value);
end;

procedure TMainView.BtnSimulateIFutureClick(Sender: TObject);
var
  LFuture: ITask;
  LResult: string;
begin
  LFuture:= TTask.Run(
    procedure
    begin
      Sleep(3000);
      LResult := '✅ Executed at this time:' + TimeToStr(Now);
    end);

  LFuture.Wait(); // Simulate LFutureValue.Value ..
  LogReply(LResult);
end;

procedure TMainView.BtnMonitorSolutionClick(Sender: TObject);
begin
  var LFutureValue := TTask.Future<string>(function: string
    begin
      Sleep(3000);
      Result := '✅ Executed at this time:' + TimeToStr(Now);
    end);

  TTask.Run(procedure begin // Start TTask <LFutureValue> Status Observer Every 100 MilliSec...
    while not (LFutureValue.Status in
      [TTaskStatus.Completed, TTaskStatus.Canceled, TTaskStatus.Exception]) do
      TThread.Sleep(100); // Reduce CPU Usage ..

    TThread.Queue(nil, procedure begin
      if LFutureValue.Status = TTaskStatus.Completed then
        LogReply(LFutureValue.Value) else
        LogReply('Future Failled or Canceled !!');
        LFutureValue := nil; // release `IFuture<T>` reference to avoid Memory Leak (TCompleteEventWrapper etc of internal thread pool that service the TTask).
    end);
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

  TTask.Run(  // Start TTask Wait for <LFuture.Value> Outside MainThread ..
    procedure
    var
      LValue: Integer;
    begin
      LValue := LFuture.Value; // Block or wait inside background thread

      TThread.Queue(nil,
        procedure
        begin
          LogReply('Result is ' + LValue.ToString); // update UI on main thread
          LFuture := nil; // release `IFuture<T>` reference to avoid Memory Leak (TCompleteEventWrapper etc of internal thread pool that service the TTask).
        end);
    end);
end;

procedure TMainView.BtnStartWithHelperClick(Sender: TObject);
begin
  TSimpleFuture<string>.Run(function: string begin
    Sleep(3000);
    Result := '✅ Executed at this time:' + TimeToStr(Now);
  end, LogReply);
end;

end.
