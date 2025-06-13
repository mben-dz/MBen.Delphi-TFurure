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

class procedure TSimpleFuture<T>.Run
  (const aQuery: TFunc<T>;
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
  LFuture := TTask.Future<T>(function: T
  begin
    Result := aQuery();
  end);

  TTask.Run(procedure
  var
    LReply: T;
  begin
    LReply := LFuture.Value;

    TThread.Queue(nil, procedure begin
      aReply(LReply);
      LFuture := nil;
    end);

  end)
end;

end.
