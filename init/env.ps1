param (
	[string]$gitDirectory = $( Read-Host "Please enter the directory location of git.exe."),
	[string]$solutionDirectory = $( Read-Host "Where do you want to setup your Frapid repository?", "")
)

if (([string]::IsNullOrEmpty($gitDirectory)))
{
	$Host.UI.WriteErrorLine("Invalid location for git directory.")
	return
}


if (([string]::IsNullOrEmpty($solutionDirectory)))
{
	$Host.UI.WriteErrorLine("Invalid location for solution directory.")
	return
}

$pathToGit = [IO.Path]::Combine($gitDirectory, "git.exe");

if(![System.IO.File]::Exists($pathToGit)){
	$Host.UI.WriteErrorLine("The directory you specified does not contain the git executable. Please download git for Windows and then try again.")
	return
}


if( -Not (Test-Path -Path $solutionDirectory ) )
{
	$Host.UI.WriteErrorLine("The solution directory was not found. Please specify a correct path.")
    #New-Item -ItemType directory -Path $solutionDirectory
	return;
}

"Writing environment variables"
Set-Content ./env/GitDirectory.txt $gitDirectory
Set-Content ./env/SolutionDirectory.txt $solutionDirectory

 
#cmd /c pause | out-null
