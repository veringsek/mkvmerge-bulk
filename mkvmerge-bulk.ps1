param (
    [Alias("s")][string]$Script = $( Get-Clipboard ),
    [Alias("o")][string]$Output = '!.cmd',
    [Alias("e", "Ext")][string]$Extension = 'mkv'
)
# $Script = $args[0]
# $Output = $args[1]
if (!($Script)) {
    $Script = Get-Clipboard
}
if (!($Output)) {
    $Output = '!.cmd'
}
$file = ([regex]('([a-zA-Z]:\\([^\\"]+\\)+)([^"]+)\.' + $Extension)).Matches($Script)
$path = $file[-1].Groups[1].Value
$path = "$path$Output".Replace('^', '')
$filename = $file[-1].Groups[3].Value
if (!($filename)) {
    Write-Error "File name not found."
    Write-Error $Script
    exit
}
Write-Output "Detect file name $filename"
Write-Output "Output to $path"
$Script = $Script.Replace($filename, '%%~nf')
$Script = "chcp 65001`r`nfor %%f in (*.$Extension) do $Script`r`npause"
Write-Output $Script | Out-File -LiteralPath $path -Encoding utf8
Write-Output "Complete"