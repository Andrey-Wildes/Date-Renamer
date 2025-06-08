# Caminho da pasta onde os arquivos estão localizados
$folderPath = "C:\Users\Usuario\Desktop\$Caminho do seu diretorio$"
# Obter todos os arquivos na pasta
$files = Get-ChildItem -Path $folderPath -File
foreach ($file in $files) {
    # Obter a data de modificação do arquivo
    $modificationDate = $file.LastWriteTime
    # Formatar a data no formato desejado (ano-mês-dia_hora-minuto-segundo)
    $formattedDate = $modificationDate.ToString("yyyy-MM-dd_HH-mm-ss")
    # Criar o novo nome de arquivo com a data de modificação e a extensão original
    $newFileName = "$formattedDate$($file.Extension)"
    # Caminho completo para o novo arquivo
    $newFilePath = Join-Path -Path $folderPath -ChildPath $newFileName
    # Verificar se o novo nome já existe para evitar sobrescrita
    $counter = 1
    while (Test-Path -Path $newFilePath) {
        $newFileName = "$formattedDate`_`$counter$($file.Extension)"
        $newFilePath = Join-Path -Path $folderPath -ChildPath $newFileName
        $counter++
        # Adicione uma verificação de segurança para evitar loops infinitos
        if ($counter -gt 100) {
            Write-Output "Não foi possível renomear o arquivo $($file.FullName) após 100 tentativas."
            break
        }
    }
    # Verifique novamente se o novo nome é diferente do original antes de renomear
    if ($file.FullName -ne $newFilePath) {
        # Renomear o arquivo
        Rename-Item -Path $file.FullName -NewName $newFilePath
    }
}
Write-Output "Arquivos renomeados com sucesso!"