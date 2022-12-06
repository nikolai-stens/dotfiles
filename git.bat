call git.exe status
set arg1 = %1
call git.exe add .
call git.exe commit -m %1
call git.exe push
