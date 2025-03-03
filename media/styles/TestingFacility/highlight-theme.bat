@echo off
setlocal enabledelayedexpansion

:: Loop through all the files in the directory
for %%f in (*.css) do (
    set "filename=%%~nf"

    :: Create a temporary file
    set "tempfile=%%~f.tmp"

    :: Write the first line to the temporary file
    echo [highlight-theme="!filename!"] { > "!tempfile!"

    :: Append the contents of the original file to the temporary file
    type "%%f" >> "!tempfile!"

    :: Write the last line to the temporary file
    echo.>> "!tempfile!"
    echo }>> "!tempfile!"

    :: Replace the original file with the modified file
    move /y "!tempfile!" "%%f"
)

echo All files have been updated.
