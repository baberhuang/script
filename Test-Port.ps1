function Test-Port
{
    Param([string]$ComputerName,$port =,$timeout = 5000)
    try
    {
        $tcpclient = New-Object -TypeName system.Net.Sockets.TcpClient
        $iar = $tcpclient.BeginConnect($ComputerName,$port,$null,$null)
        $wait = $iar.AsyncWaitHandle.WaitOne($timeout,$false)
        if(!$wait)
        {
            $tcpclient.Close()
            return $false
        }
        else
        {
            # Close the connection and report the error if there is one
             
            $null = $tcpclient.EndConnect($iar)
            $tcpclient.Close()
            return $true
        }
    }
    catch
    {
        $false
    }
}

Test-Port -ComputerName www.baidu.com -Port 80