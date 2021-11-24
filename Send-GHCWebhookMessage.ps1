function Send-GHCWebhookMessage {
    [CmdletBinding()]
    param (
        # uri
        [Parameter(Mandatory)]
        [string]
        $URI,
        # Message
        [Parameter(Mandatory)]
        [hashtable]
        $Message,
        # Proxy URI
        [String]
        $proxy,
        # Proxy Credential
        #   Only valid if Proxy parameter is also used
        [ValidateScript({($null -ne $proxy) })]
        [pscredential]
        $ProxyCredential
    )

    begin {
    }

    process {
        $JSON = ConvertTo-Json $Message -Depth 50
        $JSON

        # Build splatting base hashtable
        $splat=@{
            URI = $URI
            Method = 'POST'
            Headers = @{"Content-Type" = 'Application/json; charset=UTF-8'}
            Body = $JSON
        }
        if ($proxy) {
            # If proxy parameter specified, add it to the splatting hashtable
            $splat['Proxy'] = $proxy
            if ($ProxyCredential) {
                # if ProxyCredential parameter specified, add it to the splatting hashtable
                $splat['ProxyCredential'] = $ProxyCredential
            }
        }
        Invoke-WebRequest @splat
    }

    end {
    }
}
