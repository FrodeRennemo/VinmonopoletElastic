
function downloadfile() {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    mkdir download -force
    iwr -outfile "download/products.csv" "https://www.vinmonopolet.no/medias/sys_master/products/products/hbc/hb0/8834253127710/produkter.csv"
    gc download/products.csv  | set-content -encoding UTF8  download/iconproducts.csv

}

filter isNumeric ($input) {
    return $input -is [byte]  -or $input -is [int16]  -or $input -is [int32]  -or $input -is [int64]  `
       -or $input -is [sbyte] -or $input -is [uint16] -or $input -is [uint32] -or $input -is [uint64] `
       -or $input -is [float] -or $input -is [double] -or $input -is [decimal]
}

function importdata() {

    Write-Host "started processing at $(Get-Date)"
    $tpl = gc "mapping_fielddata.json"
    $res = Invoke-WebRequest -Method PUT -Uri "http://localhost:9200/_template/vinmonopolettpl" -Body $tpl 
    $file = import-csv .\download\iconproducts.csv -Delimiter ";" -Encoding UTF8
    $fields = @("Alkohol","Pris", "Volum", "Bitterhet","Literpris","Sukker", "Syre")
    foreach ($line in $file) {
        foreach($field in $fields){
        
            if($line.$field -eq "Ukjent"){
                $line.$field = "" 
            }
            else {
            try {
                $line.$field = $line.$field.Replace(",",".")
                $line.$field = [decimal]$line.$field
                }
                catch  {
                    Write-host "could not convert field $field"
                }    
        }
      }
    
    $body = ConvertTo-Json $line
    $postData = [System.Text.Encoding]::UTF8.GetBytes($body)
    #$resp =   Invoke-WebRequest -Method POST -Uri "http://localhost:9200/vinmonopolet/produkt/$($line.Varenummer)" -Body $postData 
    $resp =   Invoke-WebRequest -Method POST -Uri "http://localhost:9200/vinmonopolet/produkt" -Body $postData 
    if($resp.StatusCode -ne  201){
        Write-Host $resp
        Write-host $body
    }
    
    }
    Write-Host "finished processing at $(Get-Date)"
}
downloadfile
importdata