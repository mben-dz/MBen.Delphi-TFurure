unit API.Helpers;

interface
uses
  System.Classes,
  System.SysUtils,
  System.Threading;

type
  TConstProc<T> = reference to procedure (const Arg1: T);

  TSimpleFuture<T> = class
    class procedure Run(const aQuery: TFunc<T>; const aReply: TConstProc<T>); static;
    class procedure RunFuture(const aQuery: TFunc<T>; const aReply: TConstProc<T>); static;
  end;

implementation

{ TSimpleFuture<T> }

class procedure TSimpleFuture<T>.Run(
  const aQuery: TFunc<T>;
  const aReply: TConstProc<T>);
begin
  TTask.Run(procedure
  var
    LReply: T;
  begin
    LReply := aQuery();

    TThread.Queue(nil, procedure begin
      aReply(LReply);
    end);

  end)
end;

class procedure TSimpleFuture<T>.RunFuture(
  const aQuery: TFunc<T>;
  const aReply: TConstProc<T>);
var
  LFuture: IFuture<T>;
begin
  LFuture := TTask.Future<T>(aQuery); // Start LFuture here ..

  TTask.Run(procedure
  var
    LReply: T;
  begin
    LReply := LFuture.Value; // Block or wait inside background thread

    TThread.Queue(nil, procedure begin
      aReply(LReply);
      LFuture := nil; // release `IFuture<T>` reference to avoid Memory Leak (TCompleteEventWrapper etc of internal thread pool that service the TTask).
    end);

  end)
end;

end.
