{include file='modules/servers/puqHetznerDatacenter/templates/header.tpl'}
{if $is_backup_enabled}
<div class="form-group d-flex justify-content-between align-items-center">
    <h1 class="mx-auto">{$kvm->lang['Backups']}: {$backups_count}</h1>
    <button onclick="window.location.href=window.location.href.split('&remove=')[0].split('&restore=')[0];" class="btn btn-success"><i class="fa fa-exchange-alt"></i>&nbsp;{$kvm->lang['Refresh']}</button>
</div>
{if $message eq 'success'}
    <div class="alert alert-success text-center">{$kvm->lang['Successfully']}</div>
{/if}
{if $message ne 'success' && $message ne ''}
    <div class="alert alert-danger text-center">{$message}</div>
{/if}

<div {$kvm->vm_local_status_html_inactive}>
    <div class="form-group text-center">
        <form method="post" action="/clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=backups">

            {if $is_backup_enabled and $kvm->service_backups_custom_field_name == ''}
                <input type="hidden" name="turnoff_backup" value="turn_off">
                <button onclick="return ButtonTurnOnBackups();" type="submit" class="btn btn-danger"><i class="fas fa-times">&nbsp;</i>{$kvm->lang['Turn off Backups']}</button>  
            {else if $kvm->service_backups_custom_field_name == ''}
                <i>
                {$kvm->lang["Backups are automated copies of your server's disks. Each server is allocated seven backup slots. When all slots are full and a new backup is created, the oldest backup will be automatically deleted. To ensure data consistency, we recommend powering off your server before creating a backup."]}
                

                </i>
                
                <br>
                <input type="hidden" name="turnon_backup" value="turn_on">
                <button onclick="return ButtonTurnOnBackups();" type="submit" class="btn btn-success"><i class="fas fa-check">&nbsp;</i>{$kvm->lang['Turn on Backups']}</button>  
            {/if}



        </form>
    </div>
    <hr>
    
    <form method="post" action="/clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=backups">
        <div class="form-group text-center">
            <label for="backups_notes">{$kvm->lang['Backups notes']}</label>
            <input id="backups_notes" type="input" name="backup_now" class="form-control"/ required><br>
            <button onclick="return BackupNow();" type="submit" class="btn btn-success"><i class="fa fa-clone">&nbsp;</i>{$kvm->lang['Backup now']}</button>
        </div>
    </form>
    {* <i class="fa fa-info">&nbsp;</i><i>{$kvm->lang['In the case of a backup restore, all snapshots of Virtual Machine will be deleted']}</i> *}
    <table class="table table-list dataTable no-footer">
        <tbody>
        {foreach from=$backups key=key item=backup}
            <tr>
                <td>{if $backup['status'] == 'available'}<i class="fa fa-clone fa-2x"></i>{else}<img src="../modules/servers/puqHetznerDatacenter/loader.gif" title="Come back later, your backup is still busy. You can refresh the status with the 'Refresh' button.">{/if}</td>
                <td><b>{$backup['created']}</b><br>{$backup['description']}</td>
                <td>
                    {if $backup['status'] == 'available'}
                        <a onclick="return ButtonRestore();" href="/clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=backups&restore={$backup['id']|urlencode}&backup_description={$backup['description']|urlencode}" class="btn btn-warning btn-sm"><i class="fa fa-reply-all">&nbsp;</i>{$kvm->lang['Restore']}</a>
                    {else}
                        <button class="btn btn-warning btn-sm" disabled><i class="fa fa-reply-all">&nbsp;</i>{$kvm->lang['Restore']}</button>
                    {/if}
                </td>
                <td>
                    {if $backup['status'] == 'available'}
                        <a onclick="return ButtonRemove();" href="/clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=backups&remove={$backup['id']|urlencode}&backup_description={$backup['description']|urlencode}" class="btn btn-danger btn-sm"><i class="fa fa-trash">&nbsp;</i>{$kvm->lang['Remove']}</a>
                    {else}
                        <button class="btn btn-danger btn-sm" disabled><i class="fa fa-trash">&nbsp;</i>{$kvm->lang['Remove']}</button>
                    {/if}
                </td>
            </tr>
        {/foreach}
        </tbody>
    </table>
    {else}
        <div class="text-center">
            <h1><code>{$kvm->lang['The backup function is disabled!']}</code></h1>
            <hr style="margin:auto;width:50%">
            <h3>{$kvm->lang['The backup function is disabled, please enable backup, then return to the page.']}</h3>
            <i>{$kvm->lang['Backups are automated copies of your server\'s disks. Each server is allocated seven backup slots. When all slots are full and a new backup is created, the oldest backup will be automatically deleted. To ensure data consistency, we recommend powering off your server before creating a backup.']}</i>
        </div>

</div>
{/if}

<script type="text/javascript">
    function ButtonRemove(){
        result = confirm('{$kvm->lang['Are you sure?']}');
        if (result) {
            loading();
            return true
        }else {
            return false;
        }
    }

    function ButtonRestore(){
        result = confirm('{$kvm->lang['Are you sure?']}');
        if (result) {
            loading();
            return true
        }else {
            return false;
        }
    }

    function ButtonTurnOnBackups(){
        result = confirm('{$kvm->lang['Are you sure?']}');
        if (result) {
            loading();
            return true
        }else {
            return false;
        }
    }

    function BackupNow() {
        var snapshot_description = document.getElementById('backup_now').value;
        if(snapshot_description === ''){
            return true;
        }
        result = confirm('{$kvm->lang['Are you sure?']}');
        if (result) {
            loading();
            return true
        }else {
            return false;
        }
    }


</script>
{* <pre>
    {$backups|print_r}
</pre> *}