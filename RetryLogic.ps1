# RetryLogic.ps1

# Constants and initializations
$MaxRetryAttempts = 5            # Maximum number of retry attempts
$InitialBackoffDelay = 1         # Initial delay in seconds for the first retry
$MaxBackoffDelay = 32            # Maximum delay in seconds for exponential backoff
$HttpStatusRetryCodes = @(500, 502, 503, 504)  # HTTP status codes to retry on

# Function to invoke API call with retry logic and exponential backoff
function Invoke-ApiCallWithRetry {
    param (
        [scriptblock]$ApiCall
    )

    $retryCount = 0
    $backoffDelay = $InitialBackoffDelay

    while ($true) {
        try {
            # Invoke the API call
            $result = & $ApiCall

            # Check if the result is valid (example: check response status)
            if ($result.StatusCode -ge 200 -and $result.StatusCode -lt 300) {
                Write-Host "API call successful. Status Code: $($result.StatusCode) - $($result.StatusDescription)"
                return $result
            } elseif ($result.StatusCode -ge 400 -and $result.StatusCode -lt 500) {
                Handle-ClientError $result
            } elseif ($result.StatusCode -ge 500 -and $result.StatusCode -lt 600) {
                Handle-ServerError $result
            } else {
                Handle-UnknownError "Received unexpected status code: $($result.StatusCode) - $($result.StatusDescription)"
            }
        }
        catch [System.Net.WebException] {
            # Handle network errors (timeout, connection reset, etc.)
            Handle-NetworkError $_.Exception.Message
        }
        catch {
            # Handle other unexpected errors
            Handle-UnknownError $_.Exception.Message
        }

        # Increment retry count
        $retryCount++

        # Check if retry attempts exceeded
        if ($retryCount -ge $MaxRetryAttempts) {
            Write-Error "Maximum retry attempts exceeded."
            return $null
        }

        # Calculate exponential backoff delay
        $backoffDelay = [Math]::Min($MaxBackoffDelay, $InitialBackoffDelay * [Math]::Pow(2, $retryCount))

        Write-Host "Retry attempt $retryCount. Retrying in $backoffDelay seconds..."
        Start-Sleep -Seconds $backoffDelay
    }
}

# Function to handle client-side errors (4xx status codes)
function Handle-ClientError {
    param (
        [System.Net.HttpWebResponse]$response
    )

    switch ($response.StatusCode) {
        400 { Handle-BadRequestError $response }
        401 { Handle-UnauthorizedError $response }
        403 { Handle-ForbiddenError $response }
        404 { Handle-NotFoundError $response }
        default { Handle-UnknownClientError $response }
    }
}

# Function to handle server-side errors (5xx status codes)
function Handle-ServerError {
    param (
        [System.Net.HttpWebResponse]$response
    )

    switch ($response.StatusCode) {
        500 { Handle-InternalServerError $response }
        502 { Handle-BadGatewayError $response }
        503 { Handle-ServiceUnavailableError $response }
        504 { Handle-GatewayTimeoutError $response }
        default { Handle-UnknownServerError $response }
    }
}

# Function to handle network errors
function Handle-NetworkError {
    param (
        [string]$errorMessage
    )
    Write-Error "Network Error: $errorMessage"
}

# Function to handle general unknown errors
function Handle-UnknownError {
    param (
        [string]$errorMessage
    )
    Write-Error "Unknown Error: $errorMessage"
}

# Function to handle specific client-side errors
function Handle-BadRequestError {
    param (
        [System.Net.HttpWebResponse]$response
    )
    Write-Error "Bad Request Error: $($response.StatusDescription)"
    # Additional error handling logic specific to Bad Request errors
}

function Handle-UnauthorizedError {
    param (
        [System.Net.HttpWebResponse]$response
    )
    Write-Error "Unauthorized Error: $($response.StatusDescription)"
    # Additional error handling logic specific to Unauthorized errors
}

function Handle-ForbiddenError {
    param (
        [System.Net.HttpWebResponse]$response
    )
    Write-Error "Forbidden Error: $($response.StatusDescription)"
    # Additional error handling logic specific to Forbidden errors
}

function Handle-NotFoundError {
    param (
        [System.Net.HttpWebResponse]$response
    )
    Write-Error "Not Found Error: $($response.StatusDescription)"
    # Additional error handling logic specific to Not Found errors
}

function Handle-UnknownClientError {
    param (
        [System.Net.HttpWebResponse]$response
    )
    Write-Error "Unknown Client Error: $($response.StatusDescription)"
    # Additional error handling logic specific to unknown client errors
}

# Function to handle specific server-side errors
function Handle-InternalServerError {
    param (
        [System.Net.HttpWebResponse]$response
    )
    Write-Error "Internal Server Error: $($response.StatusDescription)"
    # Additional error handling logic specific to Internal Server errors
}

function Handle-BadGatewayError {
    param (
        [System.Net.HttpWebResponse]$response
    )
    Write-Error "Bad Gateway Error: $($response.StatusDescription)"
    # Additional error handling logic specific to Bad Gateway errors
}

function Handle-ServiceUnavailableError {
    param (
        [System.Net.HttpWebResponse]$response
    )
    Write-Error "Service Unavailable Error: $($response.StatusDescription)"
    # Additional error handling logic specific to Service Unavailable errors
}

function Handle-GatewayTimeoutError {
    param (
        [System.Net.HttpWebResponse]$response
    )
    Write-Error "Gateway Timeout Error: $($response.StatusDescription)"
    # Additional error handling logic specific to Gateway Timeout errors
}

function Handle-UnknownServerError {
    param (
        [System.Net.HttpWebResponse]$response
    )
    Write-Error "Unknown Server Error: $($response.StatusDescription)"
    # Additional error handling logic specific to unknown server errors
}
