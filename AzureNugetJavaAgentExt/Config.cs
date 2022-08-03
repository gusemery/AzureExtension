using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AzureNugetJavaAgentExt
{
    public class Config
    {
        public string ControllerHost { get; set; }

        public string ControllerPort { get; set; }

        public string TierName { get; set; }

        public string NodeName { get; set; }

        public string AccountName { get; set; }

        public string AccountKey { get; set; }

        public string AppName { get; set; }

        public bool SSLEnabled { get; set; }

        public string LastTimeModified { get; set; }

        public bool InstallationAborted { get; set; }

        public string AgentRuntimeDir { get; set; }
    }
}