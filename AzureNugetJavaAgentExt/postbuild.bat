@echo off
set TargetPath=%~1
set ProjectDir=%~2
set SolutionDir=%~3
set Configuration=%~4
set ProjectConfiguration=%Configuration: Not Obfuscate=%



echo Copy Site Extension Winston
copy /y "C:\Users\edward.ferron\Source\Repos\AzureNuGetJavaAgentExt\AzureNugetJavaAgentExt\default.aspx" "C:\Users\edward.ferron\Source\Repos\AzureNuGetJavaAgentExt\nuget\content" > nul
copy /y "C:\Users\edward.ferron\Source\Repos\AzureNuGetJavaAgentExt\AzureNugetJavaAgentExt\Web.config" "..\Nuget Package SiteExt\content" > nul

mkdir "..\Nuget Package SiteExt\content\bin" > nul
copy /y "..\AzureNugetWinstonSiteExt\bin\%ProjectConfiguration%\*" "Ext\content\bin" > nul
mkdir "..\Nuget Package SiteExt\content\bin\roslyn" > nul
copy /y "..\AzureNugetWinstonSiteExt\bin\%ProjectConfiguration%\roslyn\*" "..\Nuget Package SiteExt\content\bin\roslyn" > nul
mkdir "..\Nuget Package SiteExt\content\Properties" > nul
copy /y "..\AzureNugetWinstonSiteExt\Properties\*" "..\Nuget Package SiteExt\content\Properties" > nul

echo Copy pre-install tools
copy /y "..\Nuget Package SiteExt\install.cmd" "..\Nuget Package SiteExt\content" > nul
copy /y "..\Nuget Package SiteExt\env2conf.ps1" "..\Nuget Package SiteExt\content" > nul
popd

echo Building Nuget Package
"%SolutionDir%\packages\nuget.exe" pack "..\..\..\Nuget Package SiteExt\Package.nuspec" -OutputDirectory "..\..\..\Nuget Package SiteExt\out\%Configuration%" -NoPackageAnalysis
goto :eof

:CopyFile
echo Copying "%~nx1" to "%~2"
copy /y "%~1" "%~2" > nul
goto :eof