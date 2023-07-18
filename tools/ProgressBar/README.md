# ProgressBar

Handy progress bar that can be used in GUI or text interface.

- Faster than waitbar (MATLAB builtin)
- GUI interface
  - Figure automatically closes when the task is complete
- CLI interface
  - Monospaced fonts are recommended for the CLI interface
- Parfor compatibility
  - It uses parallel.pool.DataQueue
  - No file I/O, no java class, no undocumented matlab for parallel progress tracking


### Simple usage

<img width="500" src="https://github.com/elgar328/matlab-code-examples/assets/93251045/76f292bb-3bec-430f-be27-f10f2ac29c7c">  
<br> <br>
<img width="400" src="https://github.com/elgar328/matlab-code-examples/assets/93251045/b1e0e70c-40df-44e6-8c2f-963eca586dd7">  


### Task name, Parfor

<img width="500" src="https://github.com/elgar328/matlab-code-examples/assets/93251045/b39d2d97-cefb-46da-9a5c-e790bf676bbc">  
<br> <br>
<img width="400" src="https://github.com/elgar328/matlab-code-examples/assets/93251045/a1293838-36b5-4375-a69a-42e4bfe94018">  


### Text based progress bar

<img width="500" src="https://github.com/elgar328/matlab-code-examples/assets/93251045/2217b426-1907-411b-8b11-af512c20b25b">  
<br> <br>
<img width="600" src="https://github.com/elgar328/matlab-code-examples/assets/93251045/08df69d2-f074-47da-b4cb-7eca3f37a7de">  


### Faster than waitbar (MATLAB builtin)

```matlab
N = 500000;

f = waitbar(0,'waitbar');             % waitbar (MATLAB builtin)
for n = 1:N, waitbar(n/N,f); end
close(f)

PB = ProgressBar(N);                  % ProgressBar gui
for n = 1:N, PB.count; end

PB = ProgressBar(N,[],'cli');         % ProgressBar cli
for n = 1:N, PB.count; end
```

| |Elapsed time|
|------|------|
|waitbar (MATLAB builtin)|129.17 sec|
|ProgressBar gui|20.26 sec|
|ProgressBar cli|18.30 sec|

@ 2021 MacBook Pro 14" (M1 Pro)
