. .\Import.ps1

BeforeTest

Describe $module -Tags ('unit'){
    Context "$module : Module Tests" { 
        Context "Parameter Tests" { 
            Context "Exist" { 

            } 
            
            Context "Mandatory if required" { 
                
            }

            Context "Validate Set is correct" { 

            }
        }
    }
}

AfterTest