$currentDirectory = (Get-Item -Path ".\" -Verbose).FullName

function getSolutionDirectory(){
	$solutionPath = Get-Content "$currentDirectory\env\SolutionDirectory.txt";

	$directoryInfo = Get-ChildItem $solutionPath | Measure-Object;
	
	return $solutionPath;
};

"Building solutions"
$solutionPath = getSolutionDirectory;
$buildPath = "$solutionPath\frapid\builds";
cd $buildPath
$env:SystemRoot
Invoke-Expression "$env:SystemRoot\System32\cmd.exe /c all.bat"