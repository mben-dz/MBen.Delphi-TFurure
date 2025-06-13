
# 🚀 Delphi Async Helpers with `TFuture<T>`

This demo project provides a clean and safe way to perform background operations in Delphi using `TTask` and `TFuture<T>`, with a focus on keeping the **UI responsive** and preventing **memory leaks**.

## 📦 What's Inside

- `API.Helpers`: A generic async helper unit
- `Main.View`: A VCL form demonstrating good and bad usage of futures and background tasks

---

## 🔧 Helper Class: `TSimpleFuture<T>`

A simple abstraction over `TTask.Future<T>` and `TTask.Run` to make async coding easier.

```pascal
type
  TSimpleFuture<T> = class
    class procedure Run(const aQuery: TFunc<T>; const aReply: TConstProc<T>); static;
    class procedure RunFuture(const aQuery: TFunc<T>; const aReply: TConstProc<T>); static;
  end;
```

- `Run`: Runs a background task and replies to the main thread
- `RunFuture`: Uses `TFuture<T>.Value` safely from a background thread

---

## 🖼 Demo Form: `Main.View`

The form includes buttons that demonstrate the following patterns:

### ✅ Correct Usage (Non-Blocking)

#### `BtnStartWithHelper`

```pascal
TSimpleFuture<string>.RunFuture(
  function: string
  begin
    Sleep(2000);
    Result := TimeToStr(Now) + ' ✅ تم التنفيذ';
  end,
  LogReply
);
```

> ✅ Background-safe  
> ✅ Memory-safe  
> ✅ Beginner-friendly

---

### ⚠️ Incorrect Usage

#### `BtnWrongUse`

```pascal
var LFuture := TTask.Future<string>(...);
LogReply(LFuture.Value); // ❌ Blocks the main thread!
```

> ❌ This freezes the UI and defeats the purpose of async programming.

---

### ✅ Safe Manual Usage

#### `BtnWaitOutsideMainThread`

```pascal
LFuture := TTask.Future<Integer>(...);

TTask.Run(
  procedure
  begin
    var LValue := LFuture.Value;
    TThread.Queue(nil, procedure begin
      LogReply('Result: ' + LValue.ToString);
      LFuture := nil;
    end);
  end);
```

> ✅ Keeps UI free  
> ✅ Releases `LFuture` to prevent leaks

---

### 🧪 Simulating `IFuture<T>` with `ITask`

#### `BtnSimulateIFuture`

```pascal
var
  LResult: string;
  LFuture := TTask.Run(...);

TTask.Run(procedure
begin
  LFuture.Wait;
  TThread.Queue(nil, procedure begin
    LogReply(LResult);
    LFuture := nil;
  end);
end);
```

> 🧠 A useful trick for simulating `Future.Value` behavior without using `TFuture<T>`

---

### 🔁 Future Monitoring Pattern

#### `BtnMonitorSolution`

A more advanced way to ensure task completion:

```pascal
var LFuture := TTask.Future<string>(...);

TTask.Run(procedure
begin
  var LReply := LFuture.Value;

  TThread.Queue(nil, procedure begin
    LogReply(LReply);
    LFuture := nil;
  end);
end);
```

---

## 🧼 Best Practices

✅ Do  
- Use `TThread.Queue` to update UI  
- Use `TFuture.Value` **only from background threads**  
- Set `LFuture := nil` to release memory  

❌ Don’t  
- Call `.Value` on the main thread  
- Forget to release `IFuture<T>` reference  
- Update UI directly from background threads

---

## 🧰 Requirements

- Delphi XE7+  
- VCL application (Windows only)  
- `System.Threading` unit

---

## 📜 License

Free to use and modify in any personal or commercial project.

---

## 🙌 Contributions

Feel free to open an issue or PR if you want to extend this helper for things like:
- Cancellation
- Progress reporting
- `Future.ContinueWith(...)` chaining

---

### 🧠 Bonus Tip

If you're a beginner, stick with `TSimpleFuture<T>.RunFuture(...)` — it's the safest way to use `TFuture` without blocking the UI.
