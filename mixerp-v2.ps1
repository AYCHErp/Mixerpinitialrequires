Import-Module WebAdministration 

$currentDirectory = (Get-Item -Path ".\" -Verbose).FullName

function getGitDirectory(){
	$gitDirectory = Get-Content "$currentDirectory\env\GitDirectory.txt";
	
	return $gitDirectory;
};

function getSolutionDirectory(){
	$solutionPath = Get-Content "$currentDirectory\env\SolutionDirectory.txt";

	$directoryInfo = Get-ChildItem $solutionPath | Measure-Object;

	if($directoryInfo.count -gt 0){
		Write-Error "The destination $solutionPath is not empty";
		exit;
	};
	
	return $solutionPath;
};

function moveDirectoryUp($directory){
	$parent = (get-item $directory).parent.fullname;
	
	Get-ChildItem $directory -force | 
	Foreach-Object {
		$file = $_.fullName;
		$isDirectory = $_.PsIsContainer;
		
		Move-Item $file $parent -Force;
	};

	Remove-Item $directory -Force;
};

function cloneProject($url, $destination){	
	git.exe clone $url $destination
};

function cloneFrapid(){
	git.exe clone https://github.com/frapid/frapid	
	moveDirectoryUp "$solutionPath\frapid";
};

function cloneProjects($root){
	cd $root	
	cloneFrapid;
	
	cloneProject "https://github.com/mixerp/finance" "src\Frapid.Web\Areas\MixERP.Finance";
	cloneProject "https://github.com/mixerp/inventory" "src\Frapid.Web\Areas\MixERP.Inventory";
	cloneProject "https://github.com/mixerp/sales" "src\Frapid.Web\Areas\MixERP.Sales";
	cloneProject "https://github.com/mixerp/purchases" "src\Frapid.Web\Areas\MixERP.Purchases";
	cloneProject "https://github.com/mixerp/hrm" "src\Frapid.Web\Areas\MixERP.HRM";
};

function copyOverrides(){
	$source = "$currentDirectory\Overrides\*";
	$destination = $solutionPath;
	
	Copy-Item -Force -Recurse -Verbose $source -Destination $destination 
};

function createApplication(){
	$iisAppPoolName = "FrapidDevelopment"
	$iisAppPoolDotNetVersion = "v4.0"
	$iisAppName = "FrapidDevelopment"
	$directoryPath = "$solutionPath\src\Frapid.Web"

	#navigate to the app pools root
	cd IIS:\AppPools\

	#check if the app pool exists
	if (!(Test-Path $iisAppPoolName -pathType container))
	{
		#create the app pool
		$appPool = New-Item $iisAppPoolName
		$appPool | Set-ItemProperty -Name "managedRuntimeVersion" -Value $iisAppPoolDotNetVersion
	}

	#navigate to the sites root
	cd IIS:\Sites\

	#check if the site exists
	if (Test-Path $iisAppName -pathType container)
	{
		return
	}

	$bindings = @(
	   @{protocol="http";bindingInformation="*:80:postgresql.localhost"},
	   @{protocol="http";bindingInformation="*:80:sqlserver.localhost"}
	)

	#create the site
	$iisApp = New-Item $iisAppName -bindings $bindings -physicalPath $directoryPath
	$iisApp | Set-ItemProperty -Name "applicationPool" -Value $iisAppPoolName
};

function setPermission($userName){
	$acl = Get-Acl $solutionPath
	$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($userName, "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
	$acl.SetAccessRule($accessRule)
	
	Set-Acl $solutionPath $acl
};

$gitDirectory = getGitDirectory
$env:Path = $gitDirectory
$solutionPath = getSolutionDirectory

cloneProjects $solutionPath

"Copying Overrides"
copyOverrides;

"Creating IIS Application"
createApplication;

"Setting permissions"
setPermission "IIS AppPool\FrapidDevelopment";
setPermission "Authenticated Users";

"Building solutions"
$buildPath = "$solutionPath\builds";
cd $buildPath

Start-Process "cmd.exe"  "/c all.bat"
