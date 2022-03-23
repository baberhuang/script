
$result=(Test-NetConnection 180.101.49.12 -p 80 -InformationLevel Quiet -WarningAction SilentlyContinue);
if($result -eq "True"){
    echo "1";    
}else{
    echo "0";
}
