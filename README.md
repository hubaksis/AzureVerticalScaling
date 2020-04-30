Azure App Service Plan vertical scaling (changing tier, not the number of instances)

1. Create automation account. When asked - agree to create "Azure Run As Account". 
(alternatively go to Runbook -> Account Settings -> Run as accounts and create "Azure Rus As Account")
2. Import modules Az.Accounts and Az.websites in Automation account - Modules gallery
3. Create a powershell runbook
4. Paste code from the script, replace resource group name and APP PLAN name with your values
5. Run the script or setup the schedule.

6. If Azure SQL DB scaling is required - install Az.Sql module (in addition to the step #2) and uncomment the last block in the script.
