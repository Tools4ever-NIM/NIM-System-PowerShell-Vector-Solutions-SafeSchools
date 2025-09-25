#
# Vector Solutions SafeSchools.ps1 - Vector Solution SafeSchools
#
$Log_MaskableKeys = @(
    'Password',
    "proxy_password",
    "clientsecret"
)

$Global:PeopleCacheTime = Get-Date
$Global:People = [System.Collections.ArrayList]@()

$Properties = @{
    Compliance = @(
        @{ name = 'complianceId';    type = 'string';   objectfields = $null;             options = @('default','key') },
        @{ name = 'effective';       type = 'datetime'; objectfields = $null;             options = @('default') },
        @{ name = 'due';             type = 'datetime'; objectfields = $null;             options = @('default') },
        @{ name = 'expire';          type = 'datetime'; objectfields = $null;             options = @('default') },
        @{ name = 'person';          type = 'object';   objectfields = @('personId');     options = @('default') },
        @{ name = 'courseInfo';      type = 'object';   objectfields = @('courseInfoId'); options = @('default') },
        @{ name = 'typeCode';        type = 'string';   objectfields = $null;             options = @('default') },
        @{ name = 'lastRefreshed';   type = 'datetime'; objectfields = $null;             options = @('default') },
        @{ name = 'progress';        type = 'object';   objectfields = @('progressId');   options = @('default') }
    )
    CourseInfos = @(
        @{ name = 'courseInfoId';    type = 'string';   objectfields = $null;        options = @('default','key') },
        @{ name = 'title';           type = 'string';   objectfields = $null;        options = @('default') },
        @{ name = 'active';          type = 'boolean';  objectfields = $null;        options = @('default') },
        @{ name = 'topicId';         type = 'string';   objectfields = $null;        options = @('default') },
        @{ name = 'topicTitle';      type = 'string';   objectfields = $null;        options = @('default') },
        @{ name = 'variantId';       type = 'string';   objectfields = $null;        options = @('default') },
        @{ name = 'variantSubtitle'; type = 'string';   objectfields = $null;        options = @('default') }
    )
    Jobs = @(
        @{ name = 'jobId';           type = 'string';   objectfields = $null;        options = @('default','key') },
        @{ name = 'beginDate';       type = 'datetime'; objectfields = $null;        options = @('default') },
        @{ name = 'location';        type = 'object';   objectfields = 'locationId';  options = @('default') },
        @{ name = 'endDate';         type = 'datetime'; objectfields = $null;        options = @('default') },
        @{ name = 'personId';        type = 'parentObject';   objectfields = 'personId';     options = @('default') },
        @{ name = 'position';        type = 'object';   objectfields = 'positionId';  options = @('default') },
        @{ name = 'title';           type = 'string';   objectfields = $null;        options = @('default') }
    )
    Locations = @(
        @{ name = 'locationId';      type = 'string';   objectfields = $null;        options = @('default','key') },
        @{ name = 'name';            type = 'string';   objectfields = $null;        options = @('default') },
        @{ name = 'parent';          type = 'object';   objectfields = @('locationId');  options = @('default') },
        @{ name = 'code';            type = 'string';   objectfields = $null;        options = @('default') }
    )
    People = @(
        @{ name = 'personId';        type = 'string';   objectfields = $null;        options = @('default','key') },
        @{ name = 'first';           type = 'string';   objectfields = $null;        options = @('default','create_m','update_o') },
        @{ name = 'last';            type = 'string';   objectfields = $null;        options = @('default','create_m','update_o') },
        @{ name = 'username';        type = 'string';   objectfields = $null;        options = @('default','create_m','update_o') },
        @{ name = 'externalUniqueId';type = 'string';   objectfields = $null;        options = @('default','optional') },
        @{ name = 'address1';        type = 'string';   objectfields = $null;        options = @('default','optional') },
        @{ name = 'address2';        type = 'string';   objectfields = $null;        options = @('default','optional') },
        @{ name = 'address3';        type = 'string';   objectfields = $null;        options = @('default','optional') },
        @{ name = 'city';            type = 'string';   objectfields = $null;        options = @('default','optional') },
        @{ name = 'country';         type = 'string';   objectfields = $null;        options = @('default','optional') },
        @{ name = 'email';           type = 'string';   objectfields = $null;        options = @('default','create_m','update_o') },
        @{ name = 'middle';          type = 'string';   objectfields = $null;        options = @('default'),'optional' },
        @{ name = 'phone';           type = 'string';   objectfields = $null;        options = @('default','optional') },
        @{ name = 'postalCode';      type = 'string';   objectfields = $null;        options = @('default','optional') },
        @{ name = 'state';           type = 'string';   objectfields = $null;        options = @('default','optional') },
        @{ name = 'isActive';        type = 'boolean';  objectfields = $null;        options = @('default','optional') }
        @{ name = 'jobs';            type = 'object';   objectfields = @('jobId','beginDate','endDate','title','location { locationId }','position { positionId }');        options = @('hidden') }
    )
    Positions = @(
        @{ name = 'positionId';      type = 'string';   objectfields = $null;        options = @('default','key') },
        @{ name = 'code';            type = 'string';   objectfields = $null;        options = @('default') },
        @{ name = 'name';            type = 'string';   objectfields = $null;        options = @('default') },
        @{ name = 'parent';          type = 'object';   objectfields = @('positionId');  options = @('default') }
    )
    Progress = @(
        @{ name = 'progressId';      type = 'string';   objectfields = $null;        options = @('default','key') },
        @{ name = 'completed';       type = 'boolean';  objectfields = $null;        options = @('default') },
        @{ name = 'completeTime';    type = 'datetime'; objectfields = $null;        options = @('default') },
        @{ name = 'courseInfo';      type = 'object';   objectfields = 'courseInfoId'; options = @('default') },
        @{ name = 'maxQuizScore';    type = 'number';   objectfields = $null;        options = @('default') },
        @{ name = 'personId';          type = 'parentObject';   objectfields = 'personId';     options = @('default') },
        @{ name = 'compliance';      type = 'object';   objectfields = 'complianceId'; options = @('default') }
    )
}

#
# System functions
#
function Idm-SystemInfo {
    param (
        # Operations
        [switch] $Connection,
        [switch] $TestConnection,
        [switch] $Configuration,
        # Parameters
        [string] $ConnectionParams
    )

    Log info "-Connection=$Connection -TestConnection=$TestConnection -Configuration=$Configuration -ConnectionParams='$ConnectionParams'"

    if ($Connection) {
        @(
            @{
                name = 'hostname'
                type = 'textbox'
                label = 'Hostname'
                description = ''
                value = 'customer.safeschools.com'
            }
            @{
                name = 'clientId'
                type = 'textbox'
                label = 'Client ID'
                label_indent = $true
                tooltip = 'API Client ID'
                value = ''
            }
            @{
                name = 'clientsecret'
                type = 'textbox'
                password = $true
                label = 'Client Secret'
                label_indent = $true
                tooltip = 'API Client Secret'
                value = ''
            }
            @{
                name = 'use_proxy'
                type = 'checkbox'
                label = 'Use Proxy'
                description = 'Use Proxy server for requests'
                value = $false # Default value of checkbox item
            }
            @{
                name = 'proxy_address'
                type = 'textbox'
                label = 'Proxy Address'
                description = 'Address of the proxy server'
                value = 'http://127.0.0.1:8888'
                disabled = '!use_proxy'
                hidden = '!use_proxy'
            }
            @{
                name = 'use_proxy_credentials'
                type = 'checkbox'
                label = 'Use Proxy Credentials'
                description = 'Use credentials for proxy'
                value = $false
                disabled = '!use_proxy'
                hidden = '!use_proxy'
            }
            @{
                name = 'proxy_username'
                type = 'textbox'
                label = 'Proxy Username'
                label_indent = $true
                description = 'Username account'
                value = ''
                disabled = '!use_proxy_credentials'
                hidden = '!use_proxy_credentials'
            }
            @{
                name = 'proxy_password'
                type = 'textbox'
                password = $true
                label = 'Proxy Password'
                label_indent = $true
                description = 'User account password'
                value = ''
                disabled = '!use_proxy_credentials'
                hidden = '!use_proxy_credentials'
            }
            @{
                name = 'nr_of_retries'
                type = 'textbox'
                label = 'Max. number of retry attempts'
                description = ''
                value = 5
            }
            @{
                name = 'pageSize'
                type = 'textbox'
                label = 'Page Size'
                description = 'Size of each request page'
                value = 1000
            }
            @{
                name = 'retryDelay'
                type = 'textbox'
                label = 'Seconds to wait for retry'
                description = ''
                value = 2
            }
            @{
                name = 'nr_of_sessions'
                type = 'textbox'
                label = 'Max. number of simultaneous sessions'
                description = ''
                value = 1
            }
            @{
                name = 'sessions_idle_timeout'
                type = 'textbox'
                label = 'Session cleanup idle time (minutes)'
                description = ''
                value = 1
            }
        )
    }

    if ($TestConnection) {
        
    }

    if ($Configuration) {
        @()
    }

    Log info "Done"
}

function Idm-OnUnload {
}

#
# Object CRUD functions
#

function Idm-CourseInfosRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'CourseInfos'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        $properties = Get-ClassProperties -Class $Class -IncludeHidden $true

        $graphQLBody = @{ "query"= "{$($Class)({0}){nodes{$($properties -join ' ')}pageInfo{count totalCount startCursor endCursor hasNextPage hasPreviousPage}}}" }

        $splat = @{
            SystemParams = $system_params             
            Body = ($graphQLBody | ConvertTo-Json)
            Class = $Class
        }
        
        $response = Execute-Request @splat

        $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
        $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }

        $template = [ordered]@{}
        foreach ($prop in $properties.Name) {
            $template[$prop] = $null
        }
        
        # Process permission policy overrides
        $result = foreach ($item in $response) {
            $row = New-Object -TypeName PSObject -Property ([ordered]@{} + $template)

            foreach ($prop in $item.PSObject.Properties) {
                if($propertiesHT[$prop.Name].Type -eq 'object') {
                    $row.($prop.Name) = $prop.Value."$($propertiesHT[$prop.Name].objectfields)"
                    continue
                }
                
                if ($properties.Name -contains $prop.Name) {
                    $row.($prop.Name) = $prop.Value
                }
            }
            $row
        }
        $result
}

function Idm-JobsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'Jobs'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if ($Global:People.Count -eq 0 -or ((Get-Date) - $Global:PeopleCacheTime).TotalMinutes -gt 5) {
            Idm-PeopleRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        # Precompute property template
        $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
        $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }

        $template = [ordered]@{}
        foreach ($prop in $properties.Name) {
            $template[$prop] = $null
        }
        
        # Process permission policy overrides
        $result = foreach ($item in $Global:People) {
            foreach ($rowItem in $item.Jobs) {
                $row = New-Object -TypeName PSObject -Property ([ordered]@{} + $template)
                $row.personId = $item.personId

                foreach ($prop in $rowItem.PSObject.Properties) {
                    if($propertiesHT[$prop.Name].Type -eq 'object') {
                        $row.($prop.Name) = $prop.Value."$($propertiesHT[$prop.Name].objectfields)"
                        continue
                    }
                    
                    if ($properties.Name -contains $prop.Name) {
                        $row.($prop.Name) = $prop.Value
                    }
                }
                $row
            }
        }
        $result
}

function Idm-LocationsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'Locations'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        } 

        $properties = Get-ClassProperties -Class $Class -IncludeHidden $true

        $graphQLBody = @{ "query"= "{$($Class)({0}){nodes{$($properties -join ' ')}pageInfo{count totalCount startCursor endCursor hasNextPage hasPreviousPage}}}" }

        $splat = @{
            SystemParams = $system_params             
            Body = ($graphQLBody | ConvertTo-Json)
            Class = $Class
        }
        
        $response = Execute-Request @splat

        $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
        $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }

        $template = [ordered]@{}
        foreach ($prop in $properties.Name) {
            $template[$prop] = $null
        }
        
        # Process permission policy overrides
        $result = foreach ($item in $response) {
            $row = New-Object -TypeName PSObject -Property ([ordered]@{} + $template)

            foreach ($prop in $item.PSObject.Properties) {
                if($propertiesHT[$prop.Name].Type -eq 'object') {
                    $row.($prop.Name) = $prop.Value."$($propertiesHT[$prop.Name].objectfields)"
                    continue
                }
                
                if ($properties.Name -contains $prop.Name) {
                    $row.($prop.Name) = $prop.Value
                }
            }
            $row
        }
        $result
}

function Idm-PeopleRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'People'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return 
        }
        # Refresh cache if needed
        if ($script:People.Count -eq 0 -or ((Get-Date) - $script:PeopleCacheTime).TotalMinutes -gt 5) {
            $Global:People.Clear()
            $properties = Get-ClassProperties -Class $Class -IncludeHidden $true

            $graphQLBody = @{ "query"= "{$($Class)({0}){nodes{$($properties -join ' ')}pageInfo{count totalCount startCursor endCursor hasNextPage hasPreviousPage}}}" }

            $splat = @{
                SystemParams = $system_params             
                Body = ($graphQLBody | ConvertTo-Json)
                Class = $Class
            }
            
            $Global:People.AddRange(@() + (Execute-Request @splat))
        }

        $properties = Get-ClassProperties -Class $Class
        $hash_table = [ordered]@{}

        foreach ($prop in $properties.GetEnumerator()) {
            $hash_table[$prop] = ""
        }

        foreach($rowItem in $Global:People) {
            $row = New-Object -TypeName PSObject -Property $hash_table

            foreach($prop in $rowItem.PSObject.properties) {
                if(!$properties.contains($prop.Name)) { continue }
                
                $row.($prop.Name) = $prop.Value
            }

            $row
        }
}

function Idm-PeopleCreate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'People'

    if ($GetMeta) {
        #
        # Get meta data
        #
        $test = @{
            semantics = 'create'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('create_m') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('create_m') -and !$_.options.Contains('create_o') -and !$_.options.Contains('optional') } | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
        log info ($test | ConvertTo-Json)

        $test
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "https://$($system_params.hostname)/api/1.1/json/users/"

        $splat = @{
            SystemParams = $system_params
            Method = "POST"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}


function Idm-PositionsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'Positions'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        } 
        $properties = Get-ClassProperties -Class $Class -IncludeHidden $true

        $graphQLBody = @{ "query"= "{$($Class)({0}){nodes{$($properties -join ' ')}pageInfo{count totalCount startCursor endCursor hasNextPage hasPreviousPage}}}" }

        $splat = @{
            SystemParams = $system_params             
            Body = ($graphQLBody | ConvertTo-Json)
            Class = $Class
        }
        
        $response = Execute-Request @splat

        $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
        $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }

        $template = [ordered]@{}
        foreach ($prop in $properties.Name) {
            $template[$prop] = $null
        }
        
        # Process permission policy overrides
        $result = foreach ($item in $response) {
            $row = New-Object -TypeName PSObject -Property ([ordered]@{} + $template)

            foreach ($prop in $item.PSObject.Properties) {
                if($propertiesHT[$prop.Name].Type -eq 'object') {
                    $row.($prop.Name) = $prop.Value."$($propertiesHT[$prop.Name].objectfields)"
                    continue
                }
                
                if ($properties.Name -contains $prop.Name) {
                    $row.($prop.Name) = $prop.Value
                }
            }
            $row
        }
        $result
}

<#
    ## Not included due to API performance concerns ##
    ## Idm-ComplianceRead ##

    function Idm-ProgressRead {
        param (
            # Mode
            [switch] $GetMeta,    
            # Parameters
            [string] $SystemParams,
            [string] $FunctionParams

        )
            $system_params   = ConvertFrom-Json2 $SystemParams
            $function_params = ConvertFrom-Json2 $FunctionParams
            $Class = 'Progress'
            
            if ($GetMeta) {
                Get-ClassMetaData -SystemParams $SystemParams -Class $Class
                return
            } 

            $properties = Get-ClassProperties -Class $Class -IncludeHidden $true

            $graphQLBody = @{ "query"= "{ People ({0}){nodes{personId progress { $($properties -join ' ') } }pageInfo{count totalCount startCursor endCursor hasNextPage hasPreviousPage}}}" }

            $splat = @{
                SystemParams = $system_params             
                Body = ($graphQLBody | ConvertTo-Json)
                Class = 'People'
            }
            
            $response = Execute-Request @splat

            $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
            $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }

            $template = [ordered]@{}
            foreach ($prop in $properties.Name) {
                $template[$prop] = $null
            }
            
            # Process permission policy overrides
            foreach ($person in $response) {
                foreach($item in $person.progress) {
                    $row = New-Object -TypeName PSObject -Property ([ordered]@{} + $template)
                    $row.personId = $person.personId

                    foreach ($prop in $item.PSObject.Properties) {
                        if($propertiesHT[$prop.Name].Type -eq 'object') {
                            $row.($prop.Name) = $prop.Value."$($propertiesHT[$prop.Name].objectfields)"
                            continue
                        }
                        
                        if ($properties.Name -contains $prop.Name) {
                            $row.($prop.Name) = $prop.Value
                        }
                    }
                    $row
                }
            }
            $result
    }
#>

#
#   Internal Functions
#
function Execute-AuthorizationRequest {
    param (
        [hashtable] $SystemParams
    )

    $splat = @{
        Headers = @{
            "Accept" = "application/json"
            "Content-Type" = "application/x-www-form-urlencoded"
       }
        Method = "POST"
        Uri = "https://$($SystemParams.hostname)/oauth/token"
        Body = @{
            "grant_type" = "client_credentials"
            "client_id" = $SystemParams.clientId
            "client_secret" = $SystemParams.clientSecret
        }
    }

    if($SystemParams.use_proxy)
                {
                    Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
                    
        $splat["Proxy"] = $SystemParams.proxy_address

        if($SystemParams.use_proxy_credentials)
        {
            $splat["proxyCredential"] = New-Object System.Management.Automation.PSCredential ($SystemParams.proxy_username, (ConvertTo-SecureString $SystemParams.proxy_password -AsPlainText -Force) )
        }
    }

    Log verbose "$($splat.Method) Call: $($splat.Uri)"
    $response = Invoke-RestMethod @splat -ErrorAction Stop

    return $response.access_token
}

function Get-ClassProperties {
    param (
        [string] $Class,
        [boolean] $IncludeHidden = $false
    )
    $properties = [System.Collections.ArrayList]@()

    foreach($prop in $Global:Properties.$Class) {
        if( ('hidden' -in $prop.options ) -and $IncludeHidden -eq $false ) { continue }
        if($prop.type -eq 'object') {
            if($prop.objectfields.count -gt 0) {
                [void]$properties.Add("$($prop.Name) { $($prop.objectfields -join ' ') }")
            }
            continue
        }

        [void]$properties.Add($prop.Name)
    }
    
    return $properties
}

function Execute-Request {
    param (
        [hashtable] $SystemParams,
        [string] $Body,
        [string] $Class
    )
    # Get authorization token
    $authToken = Execute-AuthorizationRequest -SystemParams $SystemParams

    # Build request parameters
    $splat = @{
        Headers = @{
            Authorization = "Bearer $($authToken)"
            Accept = "application/json"
            'Content-Type' = "application/json"
        }
        Method = "POST"
        Uri = "https://$($SystemParams.hostname)/graphql"
        Body = $Body -replace '\{0\}', "first: $($SystemParams.pageSize)"
    }

    # Configure proxy if enabled
    if ($SystemParams.use_proxy) {
        # Avoid redefining TrustAllCertsPolicy class unnecessarily
        if (-not ([System.Net.ServicePointManager]::CertificatePolicy -is [TrustAllCertsPolicy])) {
            Add-Type -TypeDefinition @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@ -ErrorAction Stop
            [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
        }

        $splat["Proxy"] = $SystemParams.proxy_address

        if ($SystemParams.use_proxy_credentials) {
            $splat["ProxyCredential"] = New-Object System.Management.Automation.PSCredential (
                $SystemParams.proxy_username,
                (ConvertTo-SecureString $SystemParams.proxy_password -AsPlainText -Force)
            )
        }
    }

    # Initialize result collection
    $results = [System.Collections.ArrayList]@()

    do {
        $attempt = 0
        $retryDelay = $SystemParams.retryDelay

        # Extract 'first' and 'after' from body for logging
        $firstMatch = [regex]::Match($splat.Body, 'first:\s*(\d+)')
        $afterMatch = [regex]::Match($splat.Body, 'after:\s*\\"(.*?)\\"')
        $firstValue = if ($firstMatch.Success) { $firstMatch.Groups[1].Value } else { "N/A" }
        $afterValue = if ($afterMatch.Success) { $afterMatch.Groups[1].Value } else { "N/A" }

        do {
            try {
                $attemptSuffix = if ($attempt -gt 0) { " (Attempt $($attempt + 1))" } else { "" }
                Log verbose "$($splat.Method) Call: $($splat.Uri)$($attemptSuffix) [$($Class), first: $($firstValue), after: $($afterValue)]"
                $response = Invoke-RestMethod @splat -ErrorAction Stop

                if($response.errors.count -gt 0) {
                    foreach($item in $response.errors) {
                        Log error "$($item | ConvertTo-Json)"
                    }
                    throw "Query result returned with errors"
                }
                break
            }
            catch {
                if($errorBreak) { throw}
                
                $statusCode = $_.Exception.Response.StatusCode.value__
                if ($statusCode -eq 429 -and $attempt -lt $SystemParams.nr_of_retries) {
                    $attempt++
                    Log warning "Received $statusCode. Retrying in $retryDelay seconds..."
                    Start-Sleep -Seconds $retryDelay
                    $retryDelay *= 2 # Exponential backoff
                }
                else {
                    throw "Failed request: $_"
                }
            }
        } while ($true)

        # Collect results
        $results.AddRange(@() + $response.data.$Class.nodes)

        # Check for pagination
        if ($response.data.$Class.pageInfo.hasNextPage -ne $true ) {
            break
        }

        # Update body for next page
        $splat.Body = $Body -replace '\{0\}', "first: $($SystemParams.pageSize) after:\`"$($response.data.$Class.pageInfo.endCursor)\`""
    } while ($true)

    # Return collected results
    return $results
}

function Get-ClassMetaData {
    param (
        [string] $SystemParams,
        [string] $Class
    )

    @(
        @{
            name = 'properties'
            type = 'grid'
            label = 'Properties'
            table = @{
                rows = @( $Global:Properties.$Class | Where-Object {'hidden' -notin $_.options } | ForEach-Object {
                    @{
                        name = $_.name
                        usage_hint = @( @(
                            foreach ($opt in $_.options) {
                                if ($opt -notin @('default', 'idm', 'key')) { continue }

                                if ($opt -eq 'idm') {
                                    $opt.Toupper()
                                }
                                else {
                                    $opt.Substring(0,1).Toupper() + $opt.Substring(1)
                                }
                            }
                        ) | Sort-Object) -join ' | '
                    }
                })
                settings_grid = @{
                    selection = 'multiple'
                    key_column = 'name'
                    checkbox = $true
                    filter = $true
                    columns = @(
                        @{
                            name = 'name'
                            display_name = 'Name'
                        }
                        @{
                            name = 'usage_hint'
                            display_name = 'Usage hint'
                        }
                    )
                }
            }
            value = ($Global:Properties.$Class | Where-Object { $_.options.Contains('default') }).name
        }
    )
}