param($packageRoot)
@{
    'type' = 'website'
    'defaultFeatures' = @('renew', 'restart-iis')
    'applyAppConfig' = {
        
    }
    'deployConfig' = @{
        'SiteName'                = 'NS-local'
        'AppPoolName'             = 'NS-local'
        'AppPoolUser'             = 'NS-local'
        'AppPoolPassword'         = 'TWr0ys1ngh4m'
        'Port'                    = '18102'
        'PhysicalPath'            = 'C:\IIS\NS-local'
    }
}