#Importando arquivo CSV, sempre separado por virgula
$Teste = Import-CSV "E:\PS\fechamento\Teste.csv"
$Count = 0
              #Laço que varre as linhas do csv
             foreach($teste in $Teste)
             {
                        #variaveis que atribuem o valor do CSV, se na primeira execução nao puxar os campos, rodar e depois atribuir os cabeçalhos a variavel, ex: ($Teste.Titulo)
                        $Title = $teste.Titulo
                        $Nome = $teste.Nome
                        $Idade = $teste.Idade

                        $html += "
                        <br><br>
                        <table cellpadding=0 cellspacing=0>
                            <tbody>
                                <div> 
                                   <p>$Title </p>
                                   <p>$Nome  </p>
                                   <p>$Idade </p>
                                </div>

                            </tbody>
                         </table>"
                       #Saida do HTML, incluir o caminho, com nome e extensão
                       $html | Out-File ""
                       $html = ""
                       $Count += 1

                }
  


  

    
