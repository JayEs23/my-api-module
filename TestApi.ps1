# Import necessary scripts
. "$PSScriptRoot\ApiFunctions.ps1"
. "$PSScriptRoot\ErrorHandling.ps1"
. "$PSScriptRoot\RetryLogic.ps1"
# Optional: . "$PSScriptRoot\Utils.ps1"

# Function to authenticate and get a token from Fidemit API
function Authenticate-FidemitApi {
    param (
        [string]$username,
        [string]$password,
        [string]$apiUrl
    )

    Invoke-ApiCallWithRetry {
        $body = @{
            email = $username
            password = $password
        } | ConvertTo-Json

        $response = Post-ApiData -url "$apiUrl/v1/authentication/login" -body $body

        if ($response.StatusCode -eq 200) {
            Write-Host "Authentication successful. Token acquired."
            return $response.Data.authorization.token
        } elseif ($response.StatusCode -eq 401) {
            Handle-ApiError "Unauthorized: Invalid credentials."
        } else {
            Handle-ApiError "Unexpected status code: $($response.StatusCode)"
        }
    }
}

# Example: Function to get authenticated user profile from Fidemit API
function Get-UserProfile {
    param (
        [string]$token,
        [string]$apiUrl
    )

    Invoke-ApiCallWithRetry {
        $headers = @{
            Authorization = "Bearer $token"
        }

        $response = Get-ApiData -url "$apiUrl/v1/me" -headers $headers

        if ($response.StatusCode -eq 200) {
            Write-Host "User profile retrieved successfully."
            return $response.Data
        } elseif ($response.StatusCode -eq 401) {
            Handle-ApiError "Unauthorized: Token expired or invalid."
        } else {
            Handle-ApiError "Unexpected status code: $($response.StatusCode)"
        }
    }
}

# Example: Function to update user profile on Fidemit API
function Update-UserProfile {
    param (
        [string]$token,
        [string]$apiUrl,
        [string]$firstName,
        [string]$lastName,
        [string]$dateOfBirth,
        [string]$gender,
        [string]$profilePicture  # Example: URL to profile picture
    )

    Invoke-ApiCallWithRetry {
        $headers = @{
            Authorization = "Bearer $token"
        }

        $body = @{
            first_name = $firstName
            last_name = $lastName
            date_of_birth = $dateOfBirth
            gender = $gender
            profile_picture = $profilePicture
        } | ConvertTo-Json

        $response = Post-ApiData -url "$apiUrl/v1/update-profile" -body $body -headers $headers

        if ($response.StatusCode -eq 200) {
            Write-Host "User profile updated successfully."
            return $response.Data
        } elseif ($response.StatusCode -eq 422) {
            Handle-ApiError "Validation failed: $($response.Data.message)"
        } elseif ($response.StatusCode -eq 401) {
            Handle-ApiError "Unauthorized: Token expired or invalid."
        } else {
            Handle-ApiError "Unexpected status code: $($response.StatusCode)"
        }
    }
}

# Replace 'api_url' with your own
$fidemitApiUrl = "api_url"

# Example usage:
# Replace with actual credentials for testing
$username = "user@example.com"
$password = "password"

# Authenticate and get token
$token = Authenticate-FidemitApi -username $username -password $password -apiUrl $fidemitApiUrl

# Example: Get user profile
if ($token) {
    $profile = Get-UserProfile -token $token -apiUrl $fidemitApiUrl
    Write-Output $profile
} else {
    Write-Host "Authentication failed. Unable to retrieve user profile."
}

# Example: Update user profile
if ($token) {
    $updateResult = Update-UserProfile -token $token -apiUrl $fidemitApiUrl `
        -firstName "John" -lastName "Doe" -dateOfBirth "1990-01-01" -gender "Male" `
        -profilePicture "https://example.com/profile.jpg"

    Write-Output $updateResult
} else {
    Write-Host "Authentication failed. Unable to update user profile."
}

# End of script
