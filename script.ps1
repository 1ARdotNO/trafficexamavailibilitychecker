
function Get-Exams {
  param(
    $date
  )
  $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
  $session.UserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
  Invoke-WebRequest -UseBasicParsing -Uri "https://timebestilling-api.atlas.vegvesen.no/api/Timebestilling/booking/getavailabletime?sectionId=1693&serviceId=438&fromDate=$($date)" `
  -WebSession $session `
  -Headers @{
  "Accept"="application/json, text/plain, */*"
    "Accept-Encoding"="gzip, deflate, br, zstd"
    "Accept-Language"="en-US,en;q=0.9,nb;q=0.8,es;q=0.7,no;q=0.6"
    "Origin"="https://www.vegvesen.no"
    "Referer"="https://www.vegvesen.no/"
    "Sec-Fetch-Dest"="empty"
    "Sec-Fetch-Mode"="cors"
    "Sec-Fetch-Site"="same-site"
    "sec-ch-ua"="`"Chromium`";v=`"122`", `"Not(A:Brand`";v=`"24`", `"Google Chrome`";v=`"122`""
    "sec-ch-ua-mobile"="?0"
    "sec-ch-ua-platform"="`"macOS`""
  }
}

function Get-DatesInRange {
  param(
      [DateTime]$StartDate,
      [DateTime]$EndDate
  )

  $dates = @()

  $currentDate = $StartDate
  while ($currentDate -le $EndDate) {
      $dates += $currentDate
      $currentDate = $currentDate.AddDays(1)
  }

  return $dates | get-date -Format yyyy-MM-dd
}


$days=42

#risløkka
$results=Get-DatesInRange -StartDate (get-date) -EndDate (get-date).AddDays($days) |ForEach-Object {
  $a=$null
  write-host "Checking $_ ..."
  $a=get-exams -date $_
  if($a.content){ $a.content | ConvertFrom-Json}
}

if ($results){
  $results
}
