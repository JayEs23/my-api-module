# ApiFunctions.ps1

# Import necessary scripts
. "$PSScriptRoot\RetryLogic.ps1"
. "$PSScriptRoot\ErrorHandling.ps1"

# Bearer token for authentication
$BearerToken = "" #add tken if required

# Function to get data from an API (with Bearer token authentication)
function Get-ApiData {
    param (
        [string]$url
    )

    Invoke-ApiCallWithRetry {
        # Perform actual API call with Bearer token authentication
        $response = Invoke-RestMethod -Uri $url -Method Get -Headers @{ "Authorization" = "Bearer $BearerToken" }
        
        # Return response
        return $response
    }
}

# Function to post data to an API (with Bearer token authentication)
function Post-ApiData {
    param (
        [string]$url,
        [object]$body
    )

    Invoke-ApiCallWithRetry {
        # Perform actual API call with Bearer token authentication
        $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType 'application/json' -Headers @{ "Authorization" = "Bearer $BearerToken" }
        
        # Return response
        return $response
    }
}

# Function to put data to an API (with Bearer token authentication)
function Put-ApiData {
    param (
        [string]$url,
        [object]$body
    )

    Invoke-ApiCallWithRetry {
        # Perform actual API call with Bearer token authentication
        $response = Invoke-RestMethod -Uri $url -Method Put -Body $body -ContentType 'application/json' -Headers @{ "Authorization" = "Bearer $BearerToken" }
        
        # Return response
        return $response
    }
}

# Function to delete data from an API (with Bearer token authentication)
function Delete-ApiData {
    param (
        [string]$url
    )

    Invoke-ApiCallWithRetry {
        # Perform actual API call with Bearer token authentication
        $response = Invoke-RestMethod -Uri $url -Method Delete -Headers @{ "Authorization" = "Bearer $BearerToken" }
        
        # Return response
        return $response
    }
}

# Function to patch data on an API (with Bearer token authentication)
function Patch-ApiData {
    param (
        [string]$url,
        [object]$body
    )

    Invoke-ApiCallWithRetry {
        # Perform actual API call with Bearer token authentication
        $response = Invoke-RestMethod -Uri $url -Method Patch -Body $body -ContentType 'application/json' -Headers @{ "Authorization" = "Bearer $BearerToken" }
        
        # Return response
        return $response
    }
}
