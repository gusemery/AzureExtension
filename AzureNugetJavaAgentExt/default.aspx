<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="AzureNugetJavaAgentExt._default" %>

    <!DOCTYPE html>

    <html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <title>AppDynamics Java Azure Extension Setup</title>
        <style type="text/css">
            .auto-style1 { font-size: xx-large; }
            .textBox { width:420px; }

        </style>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous" />
    </head>

    <body>
        <form id="form1" runat="server">
               <h1 class="display-2">AppDynamics Java Agent for Windows Azure</h1>
                <table class="table">
                    <tr>
                        <th scope="row">Controller Host</th>
                        <td>
                            <asp:TextBox ID="txtBoxControllerHost" runat="server" CssClass="textBox"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Enable SSL</th>
                        <td>
                            <asp:CheckBox ID="checkBoxSsl" runat="server" OnCheckedChanged="checkBoxSsl_CheckedChanged" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Controller Port</th>
                        <td>
                            <asp:TextBox ID="txtBoxControllerPort" runat="server" CssClass="textBox"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Account Name</th>
                        <td>
                            <asp:TextBox ID="txtBoxAccName" runat="server" CssClass="textBox"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Access Key</th>
                        <td>
                            <asp:TextBox ID="txtBoxKey" runat="server" CssClass="textBox"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Application Name</th>
                        <td>
                            <asp:TextBox ID="txtBoxAppName" runat="server" CssClass="textBox"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Tier Name</th>
                        <td>
                             <asp:TextBox ID="txtTierName" runat="server" CssClass="textBox"></asp:TextBox>
                        </td>
                    </tr>
                    <!-- <tr>
                        <th scope="row">Node Name</th>
                        <td>
                             <asp:TextBox ID="txtNodeName" runat="server" CssClass="textBox"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Agent Directory</th>
                        <td>
                             <asp:TextBox ID="txtBoxAgentDir" runat="server" CssClass="textBox"></asp:TextBox>
                        </td>
                    </tr> -->
                </table>
            <p>
                <asp:Button ID="btnApply" runat="server" Text="Apply" OnClick="btnApply_Click" />
            </p>
        </form>
    </body>

    </html>