# ErrorHandling.ps1

# Function to handle API-specific errors
function Handle-ApiError {
    param (
        [string]$errorMessage
    )
    Write-Error "API Error: $errorMessage"
}

# Function to handle network errors
function Handle-NetworkError {
    param (
        [string]$errorMessage
    )
    Write-Error "Network Error: $errorMessage"
}

# Function to handle validation errors
function Handle-ValidationError {
    param (
        [string]$errorMessage
    )
    Write-Error "Validation Error: $errorMessage"
}

# Function to handle general errors
function Handle-GeneralError {
    param (
        [string]$errorMessage
    )
    Write-Error "General Error: $errorMessage"
}

# Function to handle internet connectivity issues
function Handle-NoInternetError {
    Write-Error "No Internet Connection. Please check your network connection."
}

# Function to handle unauthorized access errors
function Handle-UnauthorizedError {
    Write-Error "Unauthorized Access. Please check your credentials and try again."
}

# Function to handle timeout errors
function Handle-TimeoutError {
    Write-Error "Request Timeout. The request took too long to complete."
}

# Function to handle unknown errors
function Handle-UnknownError {
    param (
        [string]$errorMessage
    )
    Write-Error "An unknown error occurred: $errorMessage"
}
