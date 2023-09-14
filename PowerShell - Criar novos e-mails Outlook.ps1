$basePath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$mailTemplateFile = $basePath + "\mailtemplate.html"

$web = New-Object System.Net.WebClient
$ol = New-Object -comObject Outlook.Application
$web.UseDefaultCredentials = $true;
    
    #Cria o item
	$mail = $ol.CreateItem(0)
    
    #Abaixo inclui remetente, destinatátio, e quem irá na cópia
	$mail.SentOnBehalfOfName=""
	$mail.To= ""
	$mail.CC = ""
    
    #inclui o Titulo do e-mail
	$mail.Subject = [String]::Format("E-mail de teste")
    
    #E-mail pode ser personalizado inserindo HTML abaixo
	$mail.HTMLBody ="<p> Texto de exemplo do envio de e-mail</p>"
    
    #Caso tenha anexo, basta tirar o comentário das duas variaveis abaixo e incluir o caminho na variavel abaixo
    #$file = ""
	#$attach = $mail.Attachments.Add($file)
	$mail.save()

	$inspector = $mail.GetInspector
	$inspector.Display()
	