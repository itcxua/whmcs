{include file='modules/servers/puqHetznerDatacenter/templates/header.tpl'}

{if $message eq 'success'}
    <div class="alert alert-success text-center">{$kvm->lang['Successfully']}</div>
{/if}
{if $message ne 'success' && $message ne ''}
    <div class="alert alert-danger text-center">{$message}</div>
{/if}

<div {$kvm->vm_local_status_html_inactive}>
    {if $mountedISO ne ''}
        <div class="form-group text-center">

            <h2>{$kvm->lang['Mounted']}</h2>
            <h3>
                <i class="fa fa-cog fa-spin fa-fw"></i>
                <span class="sr-only">Loading...</span>
                <i class="fa fa-dot-circle"> {$mountedISO.description}</i>
            </h3>
            <a onclick="return UmountISO();" href="/clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=iso_mount&unmount=1" class="btn btn-danger"><i class="fa fa-window-close">&nbsp;</i>{$kvm->lang['Umount']}</a>
        </div>
    {/if}


    {foreach from=$isos key=folder_name item=iso_data}
        <div class="form-group">
            <details>
                <summary style="display: flex; justify-content: space-between; align-items: center;">
                    <span>
                        <i class="fas fa-plus-circle fa-1x"></i> <b>{$iso_data.description}</b> ({$iso_data.architecture})
                    </span>
                    <form method="post" action="/clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=iso_mount" style="display:inline;">
                        <input type="text" name="iso_mount" value="{$iso_data.name}" hidden>
                        <input type="text" name="iso_name" value="{$iso_data.name}" hidden>
                        <input type="text" name="iso_id" value="{$iso_data.id}" hidden>
                        <input type="text" name="iso_description" value="{$iso_data.description}" hidden>
                        <button onclick="return MountISO();" type="submit" class="btn btn-warning btn-sm"><i class="fa fa-dot-circle">&nbsp;</i><b>{$kvm->lang['Mount']}</b></button>
                    </form>
                </summary>
                <div class="row border-bottom">
                    <div class="col-md-2 d-flex align-items-center mb-2 mt-2">
                        <b>{$kvm->lang['ID']}:</b>
                    </div>
                    <div class="col-md-8 mb-2 mt-2">
                        {$iso_data.id}
                    </div>
                </div>
                <div class="row border-bottom">
                    <div class="col-md-2 d-flex align-items-center mb-2 mt-2">
                        <b>{$kvm->lang['Name']}:</b>
                    </div>
                    <div class="col-md-8 mb-2 mt-2">
                        <b style="color: purple">{$iso_data.name}</b>
                    </div>
                </div>
                <div class="row border-bottom">
                    <div class="col-md-2 d-flex align-items-center mb-2 mt-2">
                        <b>{$kvm->lang['Type']}:</b>
                    </div>
                    <div class="col-md-8 mb-2 mt-2">
                        {$iso_data.type}
                    </div>
                </div>
                {if $iso_data.size}
                <div class="row border-bottom">
                    <div class="col-md-2 d-flex align-items-center mb-2 mt-2">
                        <b>{$kvm->lang['Size']}:</b>
                    </div>
                    <div class="col-md-8 mb-2 mt-2">
                        {$iso_data.size}
                    </div>
                </div>
                {/if}
                {if $iso_data.created}
                <div class="row border-bottom">
                    <div class="col-md-2 d-flex align-items-center mb-2 mt-2">
                        <b>{$kvm->lang['Created']}:</b>
                    </div>
                    <div class="col-md-8 mb-2 mt-2">
                        {$iso_data.created}
                    </div>
                </div>
                {/if}
                {if $iso_data.status}
                <div class="row border-bottom">
                    <div class="col-md-2 d-flex align-items-center mb-2 mt-2">
                        <b>{$kvm->lang['Status']}:</b>
                    </div>
                    <div class="col-md-8 mb-2 mt-2">
                        {$iso_data.status}
                    </div>
                </div>
                {/if}
                {if $iso_data.deprecation}
                <div class="row border-bottom">
                    <div class="col-md-2 d-flex align-items-center mb-2 mt-2">
                        <b>{$kvm->lang['Deprecation']}:</b>
                    </div>
                    <div class="col-md-8 mb-2 mt-2">
                        <b>{$kvm->lang['Announced']}:</b> {$iso_data.deprecation.announced}<br>
                        <b>{$kvm->lang['Unavailable After']}:</b> {$iso_data.deprecation.unavailable_after}
                    </div>
                </div>
                {/if}
            </details>
        </div>
    {/foreach}

    {* {foreach from=$isos key=folder_name item=isos}
        <div class="form-group">
            <details>
                <summary>
                    <i class="fa fa-folder fa-1x"></i> <b>{$folder_name}</b>
                </summary>
                <table class="table table-list dataTable no-footer">
                    {foreach from=$kvm->vm_remote_iso[$folder_name] key=iso_name item=iso_data}
                        <tr>
                            <td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </td>
                            <td><i class="fa fa-file fa-2x"></i></td>
                            <td><b style="color: purple">{$iso_name}</b></td>
                            <td>
                                <form method="post" action="/clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=iso_mount">
                                    <input type="text" name="iso_mount" value="{$iso_data['volid']}" hidden>
                                    <button onclick="return MountISO();" type="submit" class="btn btn-warning"><i class="fa fa-dot-circle">&nbsp;</i><b>{$kvm->lang['Mount']}</b></button>
                                </form>
                        </tr>
                    {/foreach}
                </table>
            </details>
        </div>
    {/foreach} *}
</div>

<script type="text/javascript">
    function MountISO(){
        result = confirm('{$kvm->lang['Are you sure?']}');
        if (result) {
            loading();
            return true
        }else {
            return false;
        }
    }
    function UmountISO(){
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
    {$isos|print_r}
</pre> *}