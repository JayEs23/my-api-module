# MyApiModule.psm1

# Import all functions from ApiFunctions.ps1, ErrorHandling.ps1, RetryLogic.ps1
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
. "$scriptPath\ApiFunctions.ps1"
. "$scriptPath\ErrorHandling.ps1"
. "$scriptPath\RetryLogic.ps1"
# Import optional Utils.ps1 if needed
# . "$scriptPath\Utils.ps1"

# Export all functions from this module
Export-ModuleMember -Function *

