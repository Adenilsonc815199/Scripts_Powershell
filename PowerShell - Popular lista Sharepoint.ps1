Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
#Necessário incluir nome do site e da lista
$WebURL=""
$ListName=""
#Get Web and List Objects
$Web = Get-SPWeb $WebURL
$List = $Web.Lists[$ListName]
$date = Get-Date

for ($var = 1; $var -le 600; $var++) {
    #Cria novo item
    $NewItem = $List.AddItem()
    #usa os campos da lista como exemplo, necessário pegar o nome exato do campo na lista
    $NewItem["Title"] = "NameTitle" + $var
    $NewItem["Indice"] = 1
    $NewItem["Observação"] = "teste"  + $var

    $NewItem.Update()
}