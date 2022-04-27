$maxtime = Get-Date '23:59'
$now = Get-Date

# ask for "Active" connected users every 1 minute 
while ($maxtime.TimeOfDay -gt $now.TimeOfDay) {
	$now = Get-Date
  #and put them to a file
	Get-TSSession -State Active -ComputerName localhost | foreach {$_.UserName} >> D:\Backups\Scripts\onlineusers.txt	
	sleep 60
}

#get unique usernames from file
Get-Content D:\Backups\Scripts\onlineusers.txt | Sort-Object | Get-Unique > D:\Backups\Scripts\todayusers-unique.txt

#send to telegram
d:\distr\curl\bin\curl -X POST -F document=@"D:\Backups\Scripts\todayusers-unique.txt" -F caption="Here is, who was online today on TS02" https://api.telegram.org/BOT_TOKENT/sendDocument?chat_id=CHAT_ID

Clear-Content D:\Backups\Scripts\todayusers-unique.txt
Clear-Content D:\Backups\Scripts\onlineusers.txt
