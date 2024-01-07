# My WARC File download script - you'll need 120TB (for entire CC) or less
# if you limit it to certain indices using the file called 
# "Indices_2_per_year.txt", that contains something like:
# CC-MAIN-2023-50
# CC-MAIN-2023-23
# ...

$switch1 = $true
$switch2 = $false

# "1547583850393.61"
$startAtIndex = $none

if (! $startAtIndex) {
    $switch1 = $false
}

write-host "Opening Indices"
foreach ($i in (Get-Content -Path .\Indices_2_per_year.txt)) {
    write-host "Opening Index $i" 
    foreach ($a in (aws s3 ls s3://commoncrawl/crawl-data/$i/segments/ | Select-String -Pattern "[\d\.]*" -AllMatches).Matches) {
        if (!$switch1 -and $a.Value.contains($startAtIndex)) {
            $switch1 = $true
        }
        $switch1 = $true
        if ($a.Length -gt 10 -and $switch1) {
            $j = $a.Value
            if ((aws s3 ls s3://commoncrawl/crawl-data/$i/segments/$j/ | Select-String -Pattern "crawldiagnostics").Matches.Success) {
                foreach ($w in (aws s3 ls "s3://commoncrawl/crawl-data/$i/segments/$j/crawldiagnostics/" | select-string -pattern ".*\.warc\.gz" -AllMatches).Matches) {
                    $v = $w.Value.split(" ")[5]
                    $targetPath = "F:\CommonCrawl\$i\$v"
                    write-host $targetPath
                    while (-not (Test-Path -Path $targetPath)) {
                        try {
                            aws s3 cp "s3://commoncrawl/crawl-data/$i/segments/$j/crawldiagnostics/$v" $targetPath
                            $switch2 = $true
                        } catch {
                            if ($_.Exception.Message -match "An error occurred \(SlowDown\)") {
                                # Sleep for 2 seconds and then retry
                                Start-Sleep -Seconds 2
                                continue
                            } else {
                                throw $_
                            }
                        }
                    }
                }
            }
        }
    }
}
