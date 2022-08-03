using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Serialization;

namespace AzureNugetJavaAgentExt
{
    public partial class _default : System.Web.UI.Page
    {
        private string _azureScmConfigFile;
        private string _azureAppConfigFile;
        private string _azureAppConfigFile2;
        protected void Page_Init(object sender, EventArgs e)
        {
            ///Dev settings
            //_azureScmConfigFile = Environment.ExpandEnvironmentVariables(@"C:\Source\AppD\AppDJavaSiteExtension\AzureNugetJavaAgentExt\AzureNugetJavaAgentExt\JavaAgent\conf\usercacheconfig.xml");
            //_azureAppConfigFile = Environment.ExpandEnvironmentVariables(@"C:\Source\AppD\AppDJavaSiteExtension\AzureNugetJavaAgentExt\AzureNugetJavaAgentExt\JavaAgent\conf\controller-info.xml");
            ///Azure settings
            _azureScmConfigFile = Environment.ExpandEnvironmentVariables(@"%home%\SiteExtensions\AppDynamics.Azure.JavaAgent\JavaAgent\conf\usercacheconfig.xml");
            _azureAppConfigFile = Environment.ExpandEnvironmentVariables(@"%home%\SiteExtensions\AppDynamics.Azure.JavaAgent\JavaAgent\conf\controller-info.xml");
            _azureAppConfigFile2 = Environment.ExpandEnvironmentVariables(@"%home%\SiteExtensions\AppDynamics.Azure.JavaAgent\JavaAgent\ver4.3.5.6\conf\controller-info.xml");
            RestoreConfigToUi();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        private void RestoreConfigToUi()
        {
            try
            {
                if (File.Exists(_azureScmConfigFile))
                {
                    var serializer = new XmlSerializer(typeof(Config));
                    using (var reader = new StreamReader(_azureScmConfigFile))
                    {
                        var azureScmConfig = (Config)serializer.Deserialize(reader);
                        txtBoxControllerHost.Text = azureScmConfig.ControllerHost;
                        txtBoxControllerPort.Text = azureScmConfig.ControllerPort;
                        txtBoxAccName.Text = azureScmConfig.AccountName;
                        txtBoxKey.Text = azureScmConfig.AccountKey;
                        txtBoxAppName.Text = azureScmConfig.AppName;
                        checkBoxSsl.Checked = azureScmConfig.SSLEnabled;
                        // txtNodeName.Text = azureScmConfig.NodeName;
                        txtTierName.Text = azureScmConfig.TierName;
                        // txtBoxAgentDir.Text = azureScmConfig.AgentRuntimeDir;
                    }
                }
            }
            catch(Exception)
            { 


            }

            if (String.IsNullOrEmpty(txtBoxControllerPort.Text))
            {
                txtBoxControllerPort.Text = "80";
            }
        }

        private void SaveConfigFromUi()
        {
            var azureScmConfig = new Config
            {
                ControllerHost = txtBoxControllerHost.Text.Trim(),
                ControllerPort = txtBoxControllerPort.Text.Trim(),
                AccountName = txtBoxAccName.Text.Trim(),
                AccountKey = txtBoxKey.Text.Trim(),
                AppName = txtBoxAppName.Text.Trim(),
                SSLEnabled = checkBoxSsl.Checked,
                LastTimeModified = DateTime.Now.Ticks.ToString(),
                // NodeName = txtNodeName.Text.Trim(),
                TierName = txtTierName.Text.Trim(),
                // AgentRuntimeDir = txtBoxAgentDir.Text.Trim()
            };

            // omit xml declaration
            var settings = new XmlWriterSettings { OmitXmlDeclaration = true, Indent = true };
            var serializer = new XmlSerializer(typeof(Config));
            using (var writer = XmlWriter.Create(_azureScmConfigFile, settings))
            {
                // omit namespace
                serializer.Serialize(writer, azureScmConfig, new XmlSerializerNamespaces(new[] { XmlQualifiedName.Empty }));
            }
            try
            {
                SaveAppConfig(azureScmConfig, _azureAppConfigFile);
                SaveAppConfig(azureScmConfig, _azureAppConfigFile2);
            }
            finally
            {
                File.Copy(_azureAppConfigFile, _azureAppConfigFile2, true);
            }
            File.Copy(_azureAppConfigFile, _azureAppConfigFile2, true);
        }

        protected void checkBoxSsl_CheckedChanged(object sender, EventArgs e)
        {
            // only check if SSL is checked but port is not 443
            if (checkBoxSsl.Checked && txtBoxControllerPort.Text.Trim() != "443")
            {
                txtBoxControllerPort.Text = "443";
            }
        }

        private bool EmptyFields(bool checkAppName)
        {
            bool empty = txtBoxControllerHost.Text.Trim() == "" || txtBoxControllerPort.Text.Trim() == "" ||
                txtBoxAccName.Text.Trim() == "" || txtBoxKey.Text.Trim() == "";

            if (checkAppName)
            {
                empty = empty || txtBoxAppName.Text.Trim() == "";
            }

            return empty;
        }

        private string GetEmptyField(bool checkAppName)
        {
            string str = string.Empty;

            str += txtBoxControllerHost.Text.Trim() == "" ? " Controller Host," : "";
            str += txtBoxControllerPort.Text.Trim() == "" ? " Controller Port," : "";
            str += txtBoxAccName.Text.Trim() == "" ? " Account Name," : "";
            str += txtBoxKey.Text.Trim() == "" ? " Access Key," : "";
            str += txtTierName.Text.Trim() == "" ? " Tier Name," : "";
            // str += txtNodeName.Text.Trim() == "" ? " Node Name," : "";

            if (checkAppName)
            {
                str += txtBoxAppName.Text.Trim() == "" ? " Application Name," : "";
            }

            return str.Trim(',');
        }

        protected void btnApply_Click(object sender, EventArgs e)
        {
            if (EmptyFields(true))
            {
                string script = "alert('The" + GetEmptyField(true) + " field(s) cannot be empty!');";
                ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", script, true);
                return;
            }
            SaveConfigFromUi();
            string reminder = "alert('Success! Please restart your Azure application');";
            ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", reminder, true);
        }

        private void SaveAppConfig(Config azureScmConfig, string targetFile)
        {
            XmlDocument appXml = new XmlDocument();
            appXml.Load(targetFile);

            XmlNamespaceManager appManager = new XmlNamespaceManager(appXml.NameTable);
            XmlNode controllerNode = appXml.SelectSingleNode("/controller-info", appManager);
            ///Controller settings
            controllerNode.SelectSingleNode("controller-host").InnerText = azureScmConfig.ControllerHost;
            controllerNode.SelectSingleNode("controller-port").InnerText = azureScmConfig.ControllerPort;
            controllerNode.SelectSingleNode("controller-ssl-enabled").InnerText = XmlConvert.ToString(azureScmConfig.SSLEnabled);
            ///Application settings
            controllerNode.SelectSingleNode("application-name").InnerText = azureScmConfig.AppName;
            ///Machine settings
            controllerNode.SelectSingleNode("tier-name").InnerText = azureScmConfig.TierName;
            controllerNode.SelectSingleNode("node-name").InnerText = azureScmConfig.NodeName;
            ///Account settings
            controllerNode.SelectSingleNode("account-name").InnerText = azureScmConfig.AccountName;
            controllerNode.SelectSingleNode("account-access-key").InnerText = azureScmConfig.AccountKey;
            controllerNode.SelectSingleNode("agent-runtime-dir").InnerText = azureScmConfig.AgentRuntimeDir;
            ///Save settings to XML file.
            appXml.Save(_azureAppConfigFile);
        }
    }
}