$currentDirectory = (Get-Item -Path ".\" -Verbose).FullName

function getSolutionDirectory(){
	$solutionPath = Get-Content "$currentDirectory\env\SolutionDirectory.txt";

	$directoryInfo = Get-ChildItem $solutionPath | Measure-Object;
	
	return $solutionPath;
};

$solutionPath = getSolutionDirectory;
cd "$solutionPath\frapid\src\Frapid.Web\"

Get-ChildItem -Force -Recurse $solutionPath| where { !$_.PSIsContainer } | Where-Object {$_.extension -eq ".cs"} | remove-item -force -recurse
