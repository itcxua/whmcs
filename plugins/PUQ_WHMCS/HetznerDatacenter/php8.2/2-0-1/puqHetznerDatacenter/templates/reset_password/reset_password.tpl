{include file='modules/servers/puqHetznerDatacenter/templates/header.tpl'}

{if $message eq 'success'}
    <div class="alert alert-success text-center">{$kvm->lang['Successfully']}</div>
{/if}
{if $message ne 'success' && $message ne ''}
    <div class="alert alert-danger text-center">{$message}</div>
{/if}

<div {$kvm->vm_local_status_html_inactive}>
    <div class="text-center">
        <h4 style="color: red">{$kvm->lang['The password reset procedure will work if the packages that are responsible for the operation of cloud-init have not been removed from the virtual machine']}</h4>
        <i class="fa fa-info">&nbsp;</i><i>{$kvm->lang['If the reset procedure was successful, but the password was not changed, you need to connect to the virtual machine use the noVNC console, boot in safe mode and change the password yourself']}</i>
        <hr>
        <form method="post" action="/clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=reset_password">
            <input type="text" name="reset_password" value="1" hidden>
            <button onclick="return ResetPassword();" type="submit" class="btn btn-success"><i class="fa fa-id-card">&nbsp;</i>{$kvm->lang['Reset password']}</button>
        </form>
        <hr>
    </div>
</div>
<script type="text/javascript">
    function ResetPassword(){
        result = confirm('{$kvm->lang['Are you sure?']}');
        if (result) {
            loading();
            return true
        }else {
            return false;
        }
    }
</script>
