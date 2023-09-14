#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Parametros de site, lista origem e destino
$SiteURL = ""
$SourceFolder = ""
$TargetFolder = ""

$countExecucoes = 1

$execucoes = @(
    [pscustomobject]@{ID_Inicio=1;ID_Final=100}

)
 
Function Copy-ListItems()
{
    param
    (
        [Parameter(Mandatory=$true)] [string] $SiteURL,
        [Parameter(Mandatory=$true)] [string] $SourceFolder,
        [Parameter(Mandatory=$true)] [string] $TargetFolder
    )   
    Try {
        #Inserir os dados para conectar
        $UserName = "" 
        $Password = ""
        $SecurePassword = $Password | ConvertTo-SecureString -AsPlainText -Force
        $Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName, $SecurePassword)
     
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Cred
 
        #Obtem contexto das listas origem e destino
        $SourceList = $Ctx.Web.Lists.GetByTitle($SourceFolder)
        $TargetList = $Ctx.Web.Lists.GetByTitle($TargetFolder)
        
        #define id maximo e minimo e monta o filtro da Query
        $minID = $execucoes[$countExecucoes-1].ID_Inicio
        $maxID = $execucoes[$countExecucoes-1].ID_Final
        $filtro = "<View Scope='RecursiveAll'><Query><Where><And><Geq><FieldRef Name='ID'/><Value Type='Counter'>$minID</Value></Geq><Leq><FieldRef Name='ID'/><Value Type='Counter'>$maxID</Value></Leq></And></Where></Query></View>"

        #obtem todos os itens da lista origem
        $Query = New-Object Microsoft.SharePoint.Client.CamlQuery
        $Query.ViewXml = $filtro
        $SourceListItems = $SourceList.GetItems($Query)
        $Ctx.Load($SourceListItems)
        $Ctx.ExecuteQuery()
 
        #obtem o caminho da lista de destino e da de origem
        $SourceListFields = $SourceList.Fields
        $Ctx.Load($SourceListFields)
        $TargetListFields = $TargetList.Fields
        $Ctx.Load($TargetListFields)       
        $Ctx.ExecuteQuery()



        #varre todos os itens da coluna de origem e obtem os itens para cópia
        ForEach($SourceItem in $SourceListItems)
        {
            #cria novo item na lista destino
            $NewItem =New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
            $ListItem = $TargetList.AddItem($NewItem)
            
            Foreach($SourceField in $SourceListFields)
            { 


                    #Valida campos somente leitura, anexo e ocultas
                    If((-Not ($SourceField.ReadOnlyField)) -and (-Not ($SourceField.Hidden)) -and ($SourceField.InternalName -ne  "ContentType") -and ($SourceField.InternalName -ne  "Attachments") ) 
                    {
                        $TargetField = $TargetListFields | where { $_.Internalname -eq $SourceField.Internalname}

                        if($TargetField -ne $null)
                        {
                            #Copia o valor da coluna da origem para o destino
                            $ListItem[$TargetField.InternalName] = $SourceItem[$SourceField.InternalName]
                            $ListItem["ID_"] = $SourceItem["ID"]
                            $ListItem["Example"] = $SourceItem["Example"]
                            $ListItem["Example2"] = $SourceItem["Example2"]
                            $ListItem["Example3"] = $SourceItem["Example3"]

                        }
                    }

            }
             
            $ListItem.update()
            $Ctx.ExecuteQuery()
           
            Write-host "Copied Item to the Target List:"$SourceItem.id -f Yellow

        }
 
    }
    Catch {
        write-host -f Red "Error Copying List Items!" $_.Exception.Message
    }
} 
  
#Call the main function
foreach($exec in $execucoes)
{
    Copy-ListItems -siteURL $SiteURL -SourceFolder $SourceFolder -TargetFolder $TargetFolder
    $countExecucoes++
}




