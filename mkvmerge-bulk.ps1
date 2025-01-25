$script = $args[0]
$output = $args[1]
if (!($script)) {
    $script = Get-Clipboard
}
if (!($output)) {
    $output = '!.cmd'
}
$file = ([regex]'([a-zA-Z]:\\([^\\"]+\\)+)([^"]+)\.mkv').Matches($script)
$path = $file[-1].Groups[1].Value
$path = "$path$output".Replace('^', '')
$filename = $file[-1].Groups[3].Value
if (!($filename)) {
    Write-Error "File name not found."
    Write-Error $script
    exit
}
Write-Output "Detect file name $filename"
Write-Output "Output to $path"
$script = $script.Replace($filename, '%%~nf')
$script = "chcp 65001`r`nfor %%f in (*.mkv) do $script`r`npause"
Write-Output $script | Out-File -FilePath $path -Encoding utf8
Write-Output "Complete"