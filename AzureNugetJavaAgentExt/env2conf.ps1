if (Test-Path env:"APPD_CONTROLLER_HOST") {
    $controller_host = [string](get-item env:"APPD_CONTROLLER_HOST").Value
}
if (Test-Path env:"APPD_CONTROLLER_PORT") {
    $controller_port = [string](get-item env:"APPD_CONTROLLER_PORT").Value
}
if (Test-Path env:"APPD_ACCOUNT_NAME") {
    $account_name = [string](get-item env:"APPD_ACCOUNT_NAME").Value
}
if (Test-Path env:"APPD_ACCOUNT_KEY") {
    $account_key = [string](get-item env:"APPD_ACCOUNT_KEY").Value
}
if (Test-Path env:"APPD_APP_NAME") {
    $app_name = [string](get-item env:"APPD_APP_NAME").Value
}
if (Test-Path env:"APPD_SSL_ENABLED") {
    $ssl_enabled_int = 0;
    [bool]$ssl_enabled = $false
    if ([int32]::TryParse((get-item env:"APPD_SSL_ENABLED").Value, [ref]$ssl_enabled_int)) {
        if ($ssl_enabled_int -eq 1)
        {
            $ssl_enabled = $true
        } 
    }
}

# unattended = 1 : all env variables are written into the default controller-info.xml
# unattended = 0 : all env variables are written into local user config cache only
[int32]$unattended = 0;
if (Test-Path env:"APPD_UNATTENDED") {
    if([int32]::TryParse((get-item env:"APPD_UNATTENDED").Value, [ref]$unattended)) {
        if ($unattended -ne 1) 
        {
            $unattended = 0;
        }
    }
}

$agentConfigFile = "D:\home\SiteExtensions\AppDynamics.Azure.JavaAgent\JavaAgent\conf\controller-info.xml"
$agentConfigFile2 = "D:\home\SiteExtensions\AppDynamics.Azure.JavaAgent\JavaAgent\conf\ver4.3.5.6\controller-info.xml"
$userCacheConfigFile = "D:\home\SiteExtensions\AppDynamics.Azure.JavaAgent\JavaAgent\conf\usercacheconfig.xml"

if ($unattended -eq 1) {
    $config = New-Object System.Xml.XmlDocument
    $config.Load($agentConfigFile)

    $config_root = $config.SelectSingleNode("/controller-info")

	if (!$cache_controller_host) {
		$config_controller_host = $config_root.SelectSingleNode("controller-host")
        $cache_controller_host = $config.CreateElement('controller-host', $config.DocumentElement.xmlns)
        $config_root.ReplaceChild($cache_controller_host, $config_controller_host)
        $cache_controller_host.AppendChild($config.CreateTextNode($controller_host))
    }

	if ($controller_port) {
		$config_controller_port = $config_root.SelectSingleNode("controller-port")
        $cache_controller_port = $config.CreateElement('controller-port', $config.DocumentElement.xmlns)
        $config_root.ReplaceChild($cache_controller_port, $config_controller_port)
        $cache_controller_port.AppendChild($config.CreateTextNode($controller_port))
    }

	if ($controller_port) {
		$config_controller_port = $config_root.SelectSingleNode("controller-ssl-enabled")
        $cache_controller_port = $config.CreateElement('controller-ssl-enabled', $config.DocumentElement.xmlns)
        $config_root.ReplaceChild($cache_controller_port, $config_controller_port)
        $cache_controller_port.AppendChild($config.CreateTextNode("False"))    
		if ($ssl_enabled) {
			$cache_controller_sslenable."#text" = "true"
		}
		else {
			$cache_controller_sslenable."#text" = "false"
		}
	}

		$config.Save($agentConfigFile)
	}

$config = New-Object System.Xml.XmlDocument
if (Test-Path $userCacheConfigFile) {
    $config.Load($userCacheConfigFile)
}
$config_root = $config.SelectSingleNode('/Config')
if ($config_root -eq $null) {
    $config_root = $config.CreateElement('Config', $config.DocumentElement.xmlns)
    $config.AppendChild($config_root)
}

if ($controller_host)
{
    $cache_controller_host = $config.SelectSingleNode('/Config/ControllerHost')
    if (!$cache_controller_host) {
        $cache_controller_host = $config.CreateElement('ControllerHost', $config.DocumentElement.xmlns)
        $config_root.AppendChild($cache_controller_host)
        $cache_controller_host.AppendChild($config.CreateTextNode($controller_host))
    }
    $cache_controller_host."#text" = $controller_host
}
if ($controller_port)
{
    $cache_controller_port = $config.SelectSingleNode('/Config/ControllerPort')
    if (!$cache_controller_port) {
        $cache_controller_port = $config.CreateElement('ControllerPort', $config.DocumentElement.xmlns)
        $config_root.AppendChild($cache_controller_port)
        $cache_controller_port.AppendChild($config.CreateTextNode($controller_port))
    }
    $cache_controller_port."#text" = $controller_port
}
    
if ($ssl_enabled -ne $null)
{
    $cache_controller_sslenable = $config.SelectSingleNode('/Config/SSLEnabled')
    if (!$cache_controller_sslenable) {
        $cache_controller_sslenable = $config.CreateElement('SSLEnabled', $config.DocumentElement.xmlns)
        $config_root.AppendChild($cache_controller_sslenable)
        $cache_controller_sslenable.AppendChild($config.CreateTextNode("false"))
    }
    if ($ssl_enabled) {
        $cache_controller_sslenable."#text" = "true"
    }
    else {
        $cache_controller_sslenable."#text" = "false"
    }
}
if ($app_name)
{
    $cache_application_name = $config.SelectSingleNode('/Config/AppName')
    if (!$cache_application_name) {
        $cache_application_name = $config.CreateElement('AppName', $config.DocumentElement.xmlns)
        $config_root.AppendChild($cache_application_name)
        $cache_application_name.AppendChild($config.CreateTextNode($app_name))
    }
    $cache_application_name."#text" = $app_name
}
if ($account_name)
{
    $cache_account_name = $config.SelectSingleNode("/Config/AccountName")
    if (!$cache_account_name) {
        $cache_account_name = $config.CreateElement('AccountName', $config.DocumentElement.xmlns)
        $config_root.AppendChild($cache_account_name)
        $cache_account_name.AppendChild($config.CreateTextNode($account_name))
    }
    $cache_account_name."#text" = $account_name
}
if ($account_key)
{
    $cache_account_key = $config.SelectSingleNode("/Config/AccountKey")
    if (!$cache_account_key) {
        $cache_account_key = $config.CreateElement('AccountKey', $config.DocumentElement.xmlns)
        $config_root.AppendChild($cache_account_key)
        $cache_account_key.AppendChild($config.CreateTextNode($account_key))
    }
    $cache_account_key."#text" = $account_key
}
$lastmodified = $config.SelectSingleNode("/Config/LastTimeModified")
if (!$lastmodified) {
        $lastmodified = $config.CreateElement('LastTimeModified', $config.DocumentElement.xmlns)
        $config_root.AppendChild($lastmodified)
        $lastmodified.AppendChild($config.CreateTextNode(""))
}
$lastmodified."#text" = [string] [System.DateTime]::Now.Ticks

$config.Save($userCacheConfigFile)