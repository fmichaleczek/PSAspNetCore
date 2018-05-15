Import-Module "$pwd\PSAspNetCore" -Force

# Get PSAspNetCore Class in scope
. "$pwd\PSAspNetCore\Classes\AspNetCore\AspNetCore.ps1"
. "$pwd\Startup.ps1"
. "$pwd\Program.ps1"

# Working
# [Program]::Main('')
$RandomPort = Get-Random -Minimum 6000 -Maximum 8000   
               
$HostBuilder = [PSWebHost]::CreateDefaultBuilder()
$HostBuilder.UseEnvironment("Development") > $null
$HostBuilder.UseSetting([WebHostDefaults]::PreventHostingStartupKey, $true) > $null
$HostBuilder.CaptureStartupErrors($true) > $null
$HostBuilder.UseContentRoot($pwd) > $null
$HostBuilder.UseWebRoot("$pwd\wwwroot") > $null
$HostBuilder.UseKestrel([Action[KestrelServerOptions]]{
    param($Options)
    $Options.AddServerHeader = $false
}) > $null

$HostBuilder.UseUrls("http://*:$RandomPort") > $null
$HostBuilder.UseStartup([Startup]) > $null

$WebHost = $HostBuilder.Build()
$WebHost.Start() > $null

Start-Process "http://localhost:$RandomPort"