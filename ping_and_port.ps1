process {
	
if( $args[1] -ge 0)
 {
	 
	function Test-Port
	{
		Param([string]$ComputerName,$port,$timeout = 5000)
		try
		{
			$tcpclient = New-Object -TypeName system.Net.Sockets.TcpClient
			$iar = $tcpclient.BeginConnect($ComputerName,$port,$null,$null)
			$wait = $iar.AsyncWaitHandle.WaitOne($timeout,$false)
			if(!$wait)
			{
				$tcpclient.Close()
				return 0
			}
			else
			{
				# Close the connection and report the error if there is one
             
				$null = $tcpclient.EndConnect($iar)
				$tcpclient.Close()
				return 1
			}
		}
		catch
		{
			echo "0"
		}
	}

	Test-Port -ComputerName $args[0] -Port $args[1]
	
 }else{
	 
	$n=ping $args[0] -n 2 -w 100
	if($lastexitcode -eq 0){echo "1"}else{echo "0"}
  
 }
}