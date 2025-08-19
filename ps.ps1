# Conectar al servicio de SharePoint Online
Connect-SPOService -Url https://holamoda-admin.sharepoint.com

# Asignar permisos al nuevo usuario
Set-SPOUser -Site "https://holamodapanama-my.sharepoint.com/personal/johana_robles_holamoda_net/_layouts/15/onedrive.aspx?view=0" `
  -LoginName "demo.user@holamoda.net" `
  -IsSiteCollectionAdmin $true
