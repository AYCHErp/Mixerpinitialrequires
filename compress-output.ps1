$currentDirectory = (Get-Item -Path ".\" -Verbose).FullName

function getSolutionDirectory(){
	$solutionPath = Get-Content "$currentDirectory\env\SolutionDirectory.txt";

	$directoryInfo = Get-ChildItem $solutionPath | Measure-Object;
	
	return $solutionPath;
};

if (-not (Test-Path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"} 
$7ZipPath = "$env:ProgramFiles\7-Zip\7z.exe"


$solutionPath = getSolutionDirectory;
$archiveDirectory = "$solutionPath\frapid\src\Frapid.Web"
cd $archiveDirectory

$params = "a -aoa -tzip -mx3 release.zip -xr!Tenants\postgresql_localhost -xr!Tenants\sqlserver_localhost";
$params = $params.Split(" ")


& "$7ZipPath" $params

