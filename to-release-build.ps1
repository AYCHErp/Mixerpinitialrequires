$currentDirectory = (Get-Item -Path ".\" -Verbose).FullName

function getSolutionDirectory(){
	$solutionPath = Get-Content "$currentDirectory\env\SolutionDirectory.txt";

	$directoryInfo = Get-ChildItem $solutionPath | Measure-Object;
	
	return $solutionPath;
};

$file = getSolutionDirectory;
$file = "$file\frapid\builds\all.bat"

$contents = Get-Content $file
$contents = $contents.Replace('Configuration=Debug','Configuration=Release');

$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines($file, $contents, $Utf8NoBomEncoding)
