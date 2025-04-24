{include file='modules/servers/puqHetznerDatacenter/templates/header.tpl'}

<div class="form-group d-flex justify-content-center align-items-center">
    <h1 class="text-center w-100">{$kvm->lang['Snapshots']}: {$snapshots_count}</h1>
    <div class="position-absolute" style="right: 0;">
        <button onclick="window.location.href=window.location.href.split('&remove=')[0].split('&rollback=')[0];" class="btn btn-success"><i class="fa fa-exchange-alt"></i>&nbsp;{$kvm->lang['Refresh']}</button>
    </div>
</div>

<div class="form-group text-center">


    
    <i>
{$kvm->lang['Snapshots are immediate, complete copies of your server\'s disks. For optimal data consistency, we advise shutting down your server before capturing a snapshot. The cost for snapshots is calculated based on the amount of storage used per month.']}


</i>
</div>

{if $message eq 'success'}
    <div class="alert alert-success text-center">{$kvm->lang['Successfully']}</div>
{/if}
{if $message ne 'success' && $message ne ''}
    <div class="alert alert-danger text-center">{$message}</div>
{/if}
<div {$kvm->vm_local_status_html_inactive}>
<form method="post" action="/clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=snapshots">
    <div class="form-group text-center">
        <label for="snapshot_description">{$kvm->lang['Snapshot description']}</label>
        <input id="snapshot_description" type="input" name="snapshot_description" class="form-control"/ required><br>
        <button onclick="return TakeSnapshot();" type="submit" class="btn btn-success"><i class="fa fa-camera">&nbsp;</i>{$kvm->lang['Take Snapshot']}</button>
    </div>
</form>

<table class="table table-list dataTable no-footer">
    <tbody>
    {foreach from=$snapshots key=key item=snapshot}
        <tr>
            <td>
                {if $snapshot['status'] == 'available'}
                    <i class="fa fa-camera fa-2x"></i>
                {else}
                    <img src="../modules/servers/puqHetznerDatacenter/loader.gif" title="Come back later, your snapshot is still busy. You can refresh the status with the 'Refresh' button.">
                {/if}
            </td>
            <td><b>{$snapshot['description']}</b> ({$snapshot['created']})<br>
            {$kvm->lang['Size']}: <b>{if $snapshot['image_size'] eq ''}0{else}{sprintf("%.2f", $snapshot['image_size'])}{/if} GB</b></td>
            <td>
                {if $snapshot['status'] == 'available'}
                    <a onclick="return ButtonRollback();" href="/clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=snapshots&rollback={$snapshot['id']}&snapshot_description={htmlspecialchars($snapshot['description'])}" class="btn btn-warning btn-sm">
                        <i class="fa fa-reply">&nbsp;</i>{$kvm->lang['Rollback']}
                    </a>
                {else}
                    <button class="btn btn-warning btn-sm" disabled>
                        <i class="fa fa-reply">&nbsp;</i>{$kvm->lang['Rollback']}
                    </button>
                {/if}
            </td>
            <td>
                {if $snapshot['status'] == 'available'}
                    <a onclick="return ButtonRemove();" href="/clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=snapshots&remove={$snapshot['id']}&snapshot_description={htmlspecialchars($snapshot['description'])}" class="btn btn-danger btn-sm">
                        <i class="fa fa-trash">&nbsp;</i>{$kvm->lang['Remove']}
                    </a>
                {else}
                    <button class="btn btn-danger btn-sm" disabled>
                        <i class="fa fa-trash">&nbsp;</i>{$kvm->lang['Remove']}
                    </button>
                {/if}
            </td>
        </tr>
    {/foreach}
    </tbody>
</table>
</div>
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

    function ButtonRollback(){
        result = confirm('{$kvm->lang['Are you sure?']}');
        if (result) {
            loading();
            return true
        }else {
            return false;
        }
    }

    function TakeSnapshot() {
        var snapshot_description = document.getElementById('snapshot_description').value;
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
    {$snapshots|print_r}
</pre> *}