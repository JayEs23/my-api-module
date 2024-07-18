# MyApiModule.psd1

@{
    ModuleVersion = '1.0'
    Author = 'Samuel U. John'
    Description = 'PowerShell module for interacting with My Laravel API'
    PowerShellVersion = '5.1'
    FunctionsToExport = '*'
    NestedModules = @('ApiFunctions.ps1', 'ErrorHandling.ps1', 'RetryLogic.ps1')
   
}
