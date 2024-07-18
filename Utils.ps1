# Utils.ps1

# Utility function for logging errors
function Log-Error {
    param (
        [string]$message
    )
    # Example: Write to a log file
    Add-content -Path "error.log" -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $message"
}

# Additional utility functions can be added here
