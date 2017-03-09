Import-Module WebAdministration 

$currentDirectory = (Get-Item -Path ".\" -Verbose).FullName

function getSolutionDirectory(){
	$solutionPath = Get-Content "$currentDirectory\env\SolutionDirectory.txt";

	$directoryInfo = Get-ChildItem $solutionPath | Measure-Object;

	return $solutionPath;
};

$solutionPath = getSolutionDirectory

Remove-Item -Recurse -Force $solutionPath
mkdir $solutionPath
