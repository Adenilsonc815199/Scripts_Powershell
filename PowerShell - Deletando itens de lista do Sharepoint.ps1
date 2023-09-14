#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
   
#Parametros
$SiteURL = ""
$ListName=""
$countExecucoes = 1

#Incremento
$execucoes = @(
    [pscustomobject]@{ID_Inicio=0;ID_Final=100}

)

#Gera autenticação
$UserName = "" 
$Password = ""
$SecurePassword = $Password | ConvertTo-SecureString -AsPlainText -Force
$Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName, $SecurePassword)
 
#Setup the context
$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Ctx.Credentials = $Cred
 
#Obtem os itens para deletar, atraves do filtro
$minID = $execucoes[$countExecucoes-1].ID_Inicio
$maxID = $execucoes[$countExecucoes-1].ID_Final
$filtro = "<View Scope='RecursiveAll'><Query><Where><And><Geq><FieldRef Name='ID'/><Value Type='Counter'>$minID</Value></Geq><Leq><FieldRef Name='ID'/><Value Type='Counter'>$maxID</Value></Leq></And></Where></Query></View>"

#Roda a query para obter os itens
$Query = New-Object Microsoft.SharePoint.Client.CamlQuery
$Query.ViewXml = $filtro
$List = $Ctx.web.Lists.GetByTitle($ListName)
$ListItems = $List.GetItems($Query)

#carrega os itens
$Ctx.Load($ListItems)
$Ctx.ExecuteQuery()      

#imprime o total de itens para excluir e entra no laço de exclusões  
write-host "Total Number of List Items found:"$ListItems.Count
     foreach($exec in $execucoes)
    {
        For($i = $ListItems.Count-1; $i -ge 0; $i--)
        {
            $ListItems[$i].DeleteObject()
            Write-Host "Excluindo o Item"
            $Ctx.ExecuteQuery()
        }

        $countExecucoes++

    }


    Write-Host "All List Items deleted Successfully!"
