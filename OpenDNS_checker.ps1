#Written By Charles Weber for Automating Checking/restarting the OpenDNS connector 
#Provided under the MIT/Github licensing https://github.com/angular/angular.js/blob/master/LICENSE

$dclist = @('dc1','dc2') #input the name of the domain controllers here. 
############################
#Optional SMTP Notification#
$smtpserver = "smtp-relay.gmail.com" # Requires a configuration on Google admin console if you want to use google smtp. 
$mailfrom = "OepnDNS-Service@yourdomain.com" # Can be any email that is accepted by your smtp domain
$mailto = "reportemail@yourdomain.com" # Email address to send the report
$mailsubject = "OpenDNS-Service" # Timestamp will be added to the end.


Foreach ($dc in $dclist){
$status = Get-service -cn $dc -name "OpenDNS*"
        if ($status.Status -eq "Stopped"){
                Write-host "$dc OpenDNS service stopped"
               Get-service -ComputerName $dc -name "OpenDNS*" | Restart-Service
                Write-Host "$dc Starting OpenDNS Service"

$msg = New-Object Net.Mail.MailMessage
$smtp = New-Object Net.Mail.SmtpClient($smtpserver)
$msg.From = $mailfrom
$msg.To.Add($mailto)
$msg.subject = "$mailsubject - $(Get-Date)"
$msg.Body = "$dc OpenDNS Connector service restarted at $(Get-Date)"
$smtp.send($msg)
    }
        }
